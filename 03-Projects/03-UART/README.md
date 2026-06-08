# UART Transmitter & Receiver

A fully parameterized, FSM-based UART (Universal Asynchronous Receiver Transmitter) transceiver implemented in Verilog. Supports standard 8N1 frame format with configurable clock frequency and baud rate. The design is split into four modules - baud rate generator, transmitter, receiver, and top-level wrapper - each independently verified and integrated for full-duplex loopback testing.

---

## Module Overview

```
uart_top.v
├── baud_rate_generator.v   - TX and RX tick generation
├── uart_tx.v               - FSM-based serial transmitter
└── uart_rx.v               - FSM-based serial receiver with oversampling
```

---

## UART Frame Format (8N1)

```
IDLE | START | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | STOP | IDLE
  1  |   0   |         8 data bits (LSB first)         |  1   |  1
```

- **Start bit:** always 0 - signals beginning of frame
- **Data bits:** 8 bits, LSB transmitted first
- **Stop bit:** always 1 - marks end of frame
- **Idle:** line held HIGH when no transmission

---

## Baud Rate Generator

### Description

Generates two independent tick signals - `tx_en` for the transmitter and `rx_en` for the receiver. Each tick pulses HIGH for exactly one clock cycle at the configured interval.

- `tx_en` - one pulse every `CLK_FREQ / BAUD_RATE` cycles (one pulse per bit period)
- `rx_en` - one pulse every `CLK_FREQ / (BAUD_RATE × 16)` cycles (16× oversampling for receiver)

At default parameters (50 MHz clock, 9600 baud):
- TX: one pulse every **5208 cycles**
- RX: one pulse every **325 cycles**

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `CLK_FREQ` | 50000000 | Input clock frequency in Hz |
| `BAUD_RATE` | 9600 | Desired baud rate |

### Port Description

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `reset` | Input | 1 | Synchronous active-high reset |
| `tx_en` | Output | 1 | Transmitter baud tick |
| `rx_en` | Output | 1 | Receiver oversample tick (16×) |

### RTL Code

```verilog
/*
Baud Rate Generator for UART
CLK_FREQ  : Input clock frequency (default: 50MHz)
BAUD_RATE : Desired baud rate (default: 9600)
tx_en : one pulse every (CLK_FREQ / BAUD_RATE) cycles
          = 50MHz / 9600 = ~5208 cycles per bit => one pulse every 5208 cycles
rx_en : one pulse every (CLK_FREQ / (BAUD_RATE * 16)) cycles
           = 50MHz / 153600 = ~325 cycles => one pulse every 325 cycles
16x oversampling for accurate sampling and receiving the transmitted data without any loss
*/
module baud_rate_generator #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    input  clk, reset,
    output tx_en, rx_en
);
    localparam TX_DIV = CLK_FREQ / BAUD_RATE;
    localparam RX_DIV = CLK_FREQ / (BAUD_RATE * 16);
    reg [$clog2(TX_DIV)-1 :0] tx_counter;
    reg [$clog2(RX_DIV)-1 :0] rx_counter;
    // TX counter: counts up to TX_DIV-1, then resets
    always @(posedge clk) begin
        if (reset)
            tx_counter <= 0;
        else if (tx_counter == (TX_DIV - 1))
            tx_counter <= 0;
        else
            tx_counter <= tx_counter + 1'b1;
    end
    // RX counter: counts up to RX_DIV-1, then resets
    always @(posedge clk) begin
        if (reset)
            rx_counter <= 0;
        else if (rx_counter == (RX_DIV - 1))
            rx_counter <= 0;
        else
            rx_counter <= rx_counter + 1'b1;
    end
    // tx_en pulses high for one clock cycle every TX_DIV cycles
    assign tx_en = (tx_counter == (TX_DIV - 1)) ? 1'b1 : 1'b0;
    // rx_en pulses high for one clock cycle every RX_DIV cycles
    assign rx_en = (rx_counter == (RX_DIV - 1)) ? 1'b1 : 1'b0;
endmodule
```

---

## UART Transmitter

### Description

FSM-based serial transmitter. Accepts an 8-bit parallel input and transmits it serially in 8N1 format. Uses a registered data buffer to capture `data_in` at the moment of trigger, a bit position counter to track transmitted bits, and `tx_en` from the baud generator to control transmission timing.

`tx_start` is **active-low** - transmission begins when the signal is pulled low while a `tx_en` pulse is present. This synchronizes the start of transmission to a baud boundary, ensuring the start bit is exactly one `tx_en` period (16 `rx_en` ticks) long - which is critical for receiver alignment.

### FSM - State Diagram

```
        ~tx_start & tx_en
IDLE ─────────────────────► START ──── immediate ──► DATA ──── tx_en & bit_pos==7 ──► STOP
 ▲                                                    │                                  │
 └────────────────────────────────────────────────────┘◄──────── tx_en ─────────────────┘
```

### FSM - State Table

| State | TX Line | BUSY | Condition to Next State |
|-------|---------|------|--------------------------|
| TX_IDLE | 1 | 0 | `~tx_start & tx_en` → TX_START |
| TX_START | 0 | 1 | immediate → TX_DATA |
| TX_DATA | `temp_reg[bit_pos]` | 1 | `tx_en & bit_pos==7` → TX_STOP |
| TX_STOP | 1 | 1 | `tx_en` → TX_IDLE |

### Port Description

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `reset` | Input | 1 | Asynchronous active-high reset |
| `tx_start` | Input | 1 | Active-low transmission trigger |
| `tx_en` | Input | 1 | Baud tick from baud rate generator |
| `data_in` | Input | 8 | Parallel data to transmit |
| `tx` | Output | 1 | Serial output line |
| `busy` | Output | 1 | High during active transmission |

### RTL Code

```verilog
//UART Transmitter Module
module uart_tx(
  input clk, reset,
  input tx_start, tx_en,
  input [7:0] data_in,
  output reg tx,
  output reg busy
);
//State encoding
  localparam TX_IDLE = 2'b00;
  localparam TX_START = 2'b01;
  localparam TX_DATA = 2'b10;
  localparam TX_STOP = 2'b11;
  //Registers
  reg [1:0] state;
  reg [2:0] bit_pos = 0;
  reg [7:0] temp_reg;
  //Sequential block
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      state <= TX_IDLE;
      bit_pos = 0;
      temp_reg <=0;
      tx <= 1'b1;
      busy <= 1'b0;
    end
    else begin
      case(state)
        TX_IDLE: begin
          tx <= 1'b1;
          busy <= 1'b0;
          if(~tx_start && tx_en) begin
            busy <= 1'b1;
            temp_reg <= data_in;
            state <= TX_START;
          end
        end
        TX_START: begin
          tx <= 1'b0;
          state <= TX_DATA;
        end
        TX_DATA: begin
          busy <= 1'b1;
          if(tx_en) begin
            tx <= temp_reg[bit_pos];
            bit_pos <= bit_pos + 1'b1;
            if(bit_pos == 7) begin
              state <= TX_STOP;
              bit_pos <= 0;
            end
          end
        end
        TX_STOP: begin
          if(tx_en) begin
            state <= TX_IDLE;
            tx <= 1'b1;
            busy <= 1'b0;
          end
        end
        default: begin
          state <= TX_IDLE;
          tx = 1'b1;
          busy <= 1'b1;
        end
      endcase
    end
  end
endmodule
```

---

## UART Receiver

### Description

FSM-based serial receiver with 16× oversampling for noise-immune mid-bit sampling. Detects the start bit by monitoring the RX line, counts 16 `rx_en` ticks to consume the full start bit and align to the beginning of bit 0, then samples each data bit at its mid-point (tick 7 of 16). Reconstructs the 8-bit parallel output and asserts `ready` when a complete frame is received.

### Oversampling Strategy

Each bit period contains 16 `rx_en` ticks. The receiver samples at tick 7 (mid-point) for maximum noise immunity.

```
Bit period: |0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|
                            ↑
                      sample here (sample_count == 7)
```

RX_START counts all 16 ticks (0 to 15) to consume the entire start bit before entering RX_DATA. This works correctly because TX_START transitions immediately to TX_DATA without waiting for `tx_en` - guaranteeing the start bit is exactly one `tx_en` period (16 `rx_en` ticks) long.

Glitch rejection: if `rx` returns high during RX_START before count reaches 15, `sample_count` resets - preventing false triggers from noise.

### FSM - State Table

| State | Condition to Next State | Action |
|-------|--------------------------|--------|
| RX_START | `rx_en & sample_count==15` → RX_DATA | Count full start bit, align to bit 0 |
| RX_DATA | `rx_en & bit_pos==7 & sample_count==15` → RX_STOP | Sample at count 7, shift 8 bits |
| RX_STOP | `rx_en` → RX_START | Latch data, assert ready |

### Port Description

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `reset` | Input | 1 | Synchronous active-high reset |
| `rx` | Input | 1 | Serial input line |
| `rx_en` | Input | 1 | Oversample tick from baud rate generator |
| `ready` | Output | 1 | Pulses high for one cycle when received byte is valid |
| `data_out` | Output | 8 | Reconstructed parallel data |

### RTL Code

```verilog
//UART Receiver Module
module uart_rx(
  input clk, reset, rx, rx_en,
  //rx_en is received from baud_rate_generator module 
  //rx is the transmitted signal from the transmitter
  output reg ready,
  output reg [7:0] data_out
);
  //State Encoding
  localparam RX_START = 2'b01;
  localparam RX_DATA = 2'b10;
  localparam RX_STOP = 2'b11;
  //Registers
  reg [1:0] state;
  reg [2:0] bit_pos;
  reg [3:0] sample_count = 0;
  reg [7:0] temp_reg;
  //Sequential logic
  always @(posedge clk) begin
    if(reset) begin
      state <= RX_START;
      bit_pos <= 0;
      sample_count <= 0;
      temp_reg <= 0;
      ready <= 1'b1;
    end
    else begin
      ready <= 1'b0;
      case(state)
        RX_START: begin
          if(~rx) begin
            if(rx_en)
              sample_count <= sample_count + 1'b1;
            if(sample_count == 15) begin
              state <= RX_DATA;
              sample_count <= 0;
              bit_pos <= 0;
              temp_reg <= 0;
            end
          end
          else
            sample_count <= 0;
        end
        RX_DATA: begin
          if(rx_en) begin
            sample_count <= sample_count + 1'b1;
            if(sample_count == 7) begin
              temp_reg[bit_pos] <= rx;            //Sampling mid bit value for accuracy
            end
            if(sample_count == 15) begin
              sample_count <= 0;
              bit_pos <= bit_pos + 1'b1;
            end
            if(bit_pos == 7 && sample_count == 15) begin
              state <= RX_STOP;
            end
          end
        end
        RX_STOP: begin
          if(rx_en) begin
            data_out <= temp_reg;
            ready <= 1'b1;
            state <= RX_START;
          end
        end
      endcase
    end
  end
endmodule
```

---

## UART Top - System Integration

### Description

Top-level wrapper that instantiates and connects all three submodules. The transmitter output `tx_internal` is connected directly to the receiver input for loopback testing. The same wire is also exposed as the `tx` output port for external connectivity.

### Block Diagram

```
                    ┌─────────────────────────────────────────┐
                    │              uart_top                   │
                    │                                         │
 clk ──────────────►│──► baud_rate_generator ──► tx_en ──────►│──► uart_tx ──► tx_internal ──► tx
 reset ─────────────│    (50MHz / 9600)                       │                    │
 tx_start ──────────│    (50MHz / 153600) ──► rx_en ─────────►│──► uart_rx ◄───────┘
 data_in ───────────│                                         │       │
                    │                                         │       ├──► ready
                    │                                         │       └──► data_out
                    └─────────────────────────────────────────┘
```

### RTL Code

```verilog
//UART Module that instantiates baud_rate_generator, uart_tx, uart_rx modules
module uart_top(
  input clk, reset, tx_start, rx, 
  input [7:0] data_in,
  output tx, busy, ready,
  output [7:0] data_out
);
  wire tx_en, rx_en;
  wire tx_internal;
  baud_rate_generator baud(.clk(clk),.reset(reset),.tx_en(tx_en),.rx_en(rx_en));
  uart_tx transmitter(.clk(clk),.reset(reset),.tx_start(tx_start),.tx_en(tx_en),.data_in(data_in),.tx(tx_internal),.busy(busy));
  uart_rx receiver(.clk(clk),.reset(reset),.rx(tx_internal),.rx_en(rx_en),.ready(ready),.data_out(data_out));
  assign tx = tx_internal;
endmodule
```

---

## Testbench

### Test Plan

1. Apply reset to initialize all modules
2. Transmit `8'hAB` using `fork...join` to run TX and RX verification in parallel
3. Verify `data_out == 8'hAB` and display PASS/FAIL

### Testbench Code

```verilog
//Testbench for UART TOP Module
`timescale 1ns/1ns
module uart_tb();
  //1. Signal declaration
  reg clk;
  reg reset;
  reg tx_start = 1'b1;
  reg rx;
  reg [7:0] data_in;
  wire tx;
  wire busy;
  wire ready;
  wire [7:0] data_out;
  //2. DUT instantiation
  uart_top dut(.clk(clk),.reset(reset),.tx_start(tx_start),.rx(rx),.data_in(data_in),.tx(tx),.busy(busy),.ready(ready),.data_out(data_out));
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Tasks
  //4.1 Task to Start and Send the data
  task send_data(input [7:0] val);
    begin
      @(posedge clk);
      data_in = val;
      @(posedge clk);
      tx_start = 1'b0;
      repeat(6000) @(posedge clk);
      tx_start = 1'b1;
      $display("---DATA SENT---");
    end
  endtask
  //4.2 Task to Check Received Data
  task check_data(input [7:0] val);
    begin
      $display("---Verifying DATA---");
      @(posedge ready);
      if(data_out == val)
        $display("[PASS] SUCCESS! Verified Data: %h",data_out);
      else
        $display("[FAIL] Expected: %h; Received: %h at time %4t",val,data_out,$time);
    end
  endtask
  //5. Waveform and Stimulus
  initial begin
    //5.1 Waveform
    $dumpfile("uart_tb.vcd");
    $dumpvars(0,uart_tb);
    //5.2 Stimulus
    reset = 1'b1; rx = 1'b1;
    #12; reset = 1'b0;
    $display("---Sending DATA---");
    fork                   //Fork join: check_data listens for posedge ready while send_data is still transmitting
      send_data(8'hAB);
      check_data(8'hAB);
    join
    $finish;
  end
endmodule
```

---

## Simulation Output

```
---Sending DATA---
---Verifying DATA---
---DATA SENT---
[PASS] SUCCESS! Verified Data: ab
```

---

## Design Notes

- **Loopback testing:** `tx_internal` wire connects transmitter output directly to receiver input inside `uart_top` - enabling self-verification without external hardware
- **Active-low tx_start:** Transmission begins when `tx_start` is pulled low while `tx_en` is high - synchronizing the trigger to a baud boundary
- **Critical timing constraint:** TX_START transitions immediately to TX_DATA without waiting for `tx_en`. This ensures the start bit is exactly one `tx_en` period (16 `rx_en` ticks) long. If TX_START waited for `tx_en`, the start bit would span two `tx_en` periods (32 ticks), causing RX to sample at the wrong bit boundaries
- **Mid-bit sampling:** Receiver samples at tick 7 of each 16-tick bit period - maximizing noise immunity by sampling at the stable center of each bit
- **Start bit alignment:** RX_START counts all 16 `rx_en` ticks to consume the full start bit before entering RX_DATA, landing precisely at the boundary of bit 0
- **Glitch rejection:** If `rx` returns high during RX_START before count reaches 15, `sample_count` resets - preventing false triggers from line noise
- **Parameterized design:** Any clock frequency and baud rate combination supported via `CLK_FREQ` and `BAUD_RATE` parameters

---

## Simulation

<img width="1243" height="312" alt="image" src="https://github.com/user-attachments/assets/850d3feb-6bf6-41fb-80c9-ebff777b2b1a" />
Simulated on [EDA Playground](https://www.edaplayground.com) using Icarus Verilog.

## Author
Madhan M.P
[![LinkedIn](https://shields.io)](https://linkedin.com/in/madhan-mp)
[![GitHub](https://shields.io)](https://github.com/mpmadhan)
