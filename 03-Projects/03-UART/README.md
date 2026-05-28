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

### Port Description

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `reset` | Input | 1 | Synchronous active-high reset |
| `tx_en` | Output | 1 | Transmitter baud tick |
| `rx_en` | Output | 1 | Receiver oversample tick (16×) |

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `CLK_FREQ` | 50000000 | Input clock frequency in Hz |
| `BAUD_RATE` | 9600 | Desired baud rate |

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
    reg [$clog2(TX_DIV):0] tx_counter;
    reg [$clog2(RX_DIV):0] rx_counter;
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
FSM-based serial transmitter. Accepts an 8-bit parallel input and transmits it serially in 8N1 format. Internally uses a shift register to serialize data LSB first, a bit counter to track transmitted bits, and a baud tick input to control transmission timing.

### FSM - State Diagram

```
        tx_start=1
IDLE ─────────────► START ──── tx_en=1 ──► DATA ──── tx_en=1 & bit_count==7 ──► STOP
 ▲                                          │                                      │
 └──────────────────────────────────────────┘◄─────── tx_en=1 ────────────────────┘
```

### FSM - State Table

| State | TX Line | BUSY | Condition to Next State |
|-------|---------|------|--------------------------|
| IDLE | 1 | 0 | `tx_start=1` → START |
| START | 0 | 1 | `tx_en=1` → DATA |
| DATA | `data_reg[0]` | 1 | `tx_en=1 & bit_count==7` → STOP |
| STOP | 1 | 1 | `tx_en=1` → IDLE |

### Port Description

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `reset` | Input | 1 | Synchronous active-high reset |
| `tx_start` | Input | 1 | Pulse high to begin transmission |
| `tx_en` | Input | 1 | Baud tick from baud rate generator |
| `data_in` | Input | 8 | Parallel data to transmit |
| `tx` | Output | 1 | Serial output line |
| `busy` | Output | 1 | High during active transmission |

### RTL Code

```verilog
//UART Transmitter Module
module uart_tx(
  input clk, reset, tx_start, tx_en,
  //tx_start is the signal given by user to start trasmit, 
  //tx_en is the signal received from the baud_rate_generator module
  input [7:0] data_in,
  output reg tx, busy
);
  //State encoding
  localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam DATA = 2'b10;
  localparam STOP = 2'b11;
  //Registers
  reg [1:0] state, next_state;
  reg [7:0] data_reg;
  reg [2:0] bit_count; //counts 8 bits for DATA
  //Sequential block
  always @(posedge clk) begin
    if(reset) begin
      state <= IDLE;
      data_reg <= 0;
      bit_count <= 0;
    end
    else begin
      state <= next_state;
      if(state == IDLE && tx_start)
        data_reg <= data_in;
      if(state == DATA && tx_en) begin
        data_reg <= {1'b0,data_reg[7:1]};
        bit_count <= bit_count + 1'b1;
      end
      if(state == STOP)
        bit_count <= 0;
    end
  end
  //Combinational Next state logic block
  always @(*) begin
    case(state)
      IDLE: next_state = tx_start ? START : IDLE;
      START: next_state = tx_en ? DATA : START;
      DATA: next_state = (tx_en && bit_count == 7) ? STOP : DATA; 
      STOP: next_state = tx_en ? IDLE : STOP;
      default: next_state = IDLE;
    endcase
  end
  //Combinational Output logic
  always @(*) begin
    case(state)
      IDLE: begin
        busy = 1'b0;
        tx = 1'b1;
      end
      START: begin
        busy = 1'b1;
        tx = 1'b0;
      end
      DATA: begin
        busy = 1'b1;
        tx = data_reg[0];
      end
      STOP: begin
        busy = 1'b1;
        tx = 1'b1;
      end
      default: begin tx=1'b1; busy=1'b0; end
    endcase
  end
endmodule
```

---

## UART Receiver

### Description
FSM-based serial receiver with 16× oversampling for noise-immune mid-bit sampling. Detects the start bit by monitoring the RX line, counts 8 sample ticks to reach mid-bit of the start bit, then samples each subsequent data bit at its mid-point. Reconstructs the 8-bit parallel output and asserts `ready` when a complete frame is received.

### Oversampling Strategy

Each bit period contains 16 `rx_en` ticks. The receiver samples at tick 7 (mid-point) for maximum noise immunity.

```
Bit period: |0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|
                            ↑
                      sample here
```

Start bit uses only 8 ticks (ticks 0–7) to align to mid-point before entering DATA state.

### FSM - State Table

| State | Condition to Next State | Action |
|-------|--------------------------|--------|
| IDLE | `rx=0` → START | Detect start bit |
| START | `rx_en & sample_count==7` → DATA | Align to mid-bit |
| DATA | `rx_en & sample_count==15 & bit_count==7` → STOP | Sample & shift 8 bits |
| STOP | `rx_en & sample_count==15` → IDLE | Validate stop bit |

### Port Description

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `reset` | Input | 1 | Synchronous active-high reset |
| `rx` | Input | 1 | Serial input line |
| `rx_en` | Input | 1 | Oversample tick from baud rate generator |
| `ready` | Output | 1 | Pulses high when received byte is valid |
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
  localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam DATA = 2'b10;
  localparam STOP = 2'b11;
  //Registers
  reg [1:0] state, next_state;
  reg [2:0] bit_count;
  reg [3:0] sample_count;
  reg [7:0] temp_reg;
  //Sequential logic
  always @(posedge clk) begin
    if(reset) begin
      state <= IDLE;
      bit_count <= 0;
      sample_count <= 0;
      temp_reg <= 0;
    end
    else begin
      state <= next_state;
      case(state)
        IDLE: begin
          sample_count <= 0;
          bit_count <= 0;
        end
        START: begin
          if(rx_en)
            sample_count <= sample_count + 1'b1;
        end
        DATA: begin
          if(rx_en) begin
            sample_count <= sample_count + 1'b1;
            if(sample_count == 7)
              temp_reg <= {rx,temp_reg[7:1]};
            if(sample_count == 15) begin
              bit_count <= bit_count + 1'b1;
              sample_count <= 0;
            end
          end
        end
        STOP: begin
          if(rx_en && sample_count == 15) begin
            bit_count <= 0;
            sample_count <= 0;
          end
        end
      endcase
    end
  end
  //Combinational next state logic
  always @(*) begin
    case(state)
      IDLE: next_state = (rx == 0) ? START : IDLE;
      START: next_state = (rx_en && sample_count == 7) ? DATA : START;
      DATA: next_state = (rx_en && bit_count ==7 && sample_count == 15) ? STOP : DATA;
      STOP: next_state = (rx_en && sample_count == 15) ? IDLE : STOP;
      default: next_state = IDLE;
    endcase
  end
  //Combinational output logic
  always @(*) begin
    case(state)
      STOP: begin data_out = temp_reg; ready = 1'b1; end;
      default: begin data_out = 0; ready = 1'b0; end;
    endcase
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
                    │              uart_top                    │
                    │                                          │
 clk ──────────────►│──► baud_rate_generator ──► tx_en ──────►│──► uart_tx ──► tx_internal ──► tx
 reset ─────────────│    (50MHz / 9600)                        │                    │
 tx_start ──────────│    (50MHz / 153600) ──► rx_en ─────────►│──► uart_rx ◄───────┘
 data_in ───────────│                                          │       │
                    │                                          │       ├──► ready
                    │                                          │       └──► data_out
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
2. Transmit `8'h04` - reset mid-transmission to test reset recovery
3. Transmit `8'h07` - wait for full frame completion
4. Verify `data_out == 8'h07` and display PASS/FAIL

### Testbench Code

```verilog
//Testbench for UART Top module
`timescale 1ns/1ns
module uart_tb();
  //1. Sginal Declaration
  reg clk, reset, tx_start, rx;
  reg [7:0] data_in;
  wire tx, busy, ready;
  wire [7:0] data_out;
  //2. DUT instantiation
  uart_top dut(.clk(clk),.reset(reset),.tx_start(tx_start),.rx(1'b1),.data_in(data_in),.tx(tx),.busy(busy),.ready(ready),.data_out(data_out));
  //rx assigned 1'b1 as in uart_top module we have connected tx_internal with rx.
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("uart_tb.vcd");
    $dumpvars(0,uart_tb);
    //4.2 Display
    $display("| Time | TX_START | DATA_IN | RX | TX | BUSY | READY | DATA_OUT |");
    $display("|=-----|----------|---------|----|----|------|-------|----------|");
    //4.3 Stimulus
    reset = 1'b1; data_in = 0; tx_start = 0;
    @(posedge clk) reset = 0;
    @(posedge clk) data_in = 8'h4;
    @(posedge clk) tx_start = 1'b1;  //asserting after input
    @(posedge clk) tx_start = 0;     //deassert after assert
    repeat(50000) 
      @(posedge clk);
    @(posedge clk) reset = 1;
    @(posedge clk) reset = 0;
    @(posedge clk) data_in = 8'h7;
    @(posedge clk) tx_start = 1'b1;  //asserting after changing input
    @(posedge clk) tx_start = 0;     //deassert after assert
    //9600 Baud rate, 50MHz clock cycle => 5208 cycles per bit.
    //for a 10 bits approx 52080 cycles is required.
    repeat(100000)            
      @(posedge clk);
    if(data_out == 8'h7)
      $display("PASS: Data Received Correctly !");
    else
      $display("FAIL: Expected %h, got %h",data_in,data_out);
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("| %4t | %b | %h | %b | %b | %b | %b | %h |",$time,tx_start,data_in,rx,tx,busy,ready,data_out);
  end
endmodule
```

---

## Design Notes

- **Loopback testing:** `tx_internal` wire connects transmitter output directly to receiver input inside `uart_top` - enabling self-verification without external hardware
- **Mid-bit sampling:** Receiver samples at tick 7 of each 16-tick bit period - maximizing noise immunity
- **Start bit alignment:** START state counts only 8 ticks (half bit period) to align sample point to bit center before entering DATA state
- **Parameterized design:** Any clock frequency and baud rate combination supported via `CLK_FREQ` and `BAUD_RATE` parameters
- **Reset recovery:** Transmitter and receiver independently reset to IDLE - mid-transmission reset cleanly aborts and restarts

---

## Simulation

Simulated on EDA Playground using Icarus Verilog and EPWave.
