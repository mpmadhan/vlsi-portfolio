# Synchronous FIFO

A parameterized, synchronous First-In-First-Out (FIFO) buffer implemented in Verilog with a self-checking testbench. Supports configurable data width and depth, with built-in overflow and underflow protection.

---

## Module: `fifo_sync`

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `WIDTH` | 8 | Data width in bits |
| `DEPTH` | 16 | FIFO depth (must be a power of 2) |

### Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `reset` | Input | 1 | Synchronous active-high reset |
| `write_en` | Input | 1 | Write enable |
| `read_en` | Input | 1 | Read enable |
| `data_in` | Input | WIDTH | Data input |
| `data_out` | Output | WIDTH | Data output (registered) |
| `full` | Output | 1 | FIFO full flag |
| `empty` | Output | 1 | FIFO empty flag |

---

## Design Description

### Architecture

The FIFO uses a circular buffer implemented as a register array of size `DEPTH × WIDTH`. Two pointers - `read_ptr` and `write_ptr` - track the current read and write positions. Both pointers are `ADDR_WIDTH + 1` bits wide, where the extra MSB is used to distinguish between the full and empty conditions when both pointer lower bits are equal.

### Pointer Design

```
ADDR_WIDTH = $clog2(DEPTH)
Pointer width = ADDR_WIDTH + 1 bits
Memory address = pointer[ADDR_WIDTH-1:0]  (lower bits only)
```

The extra MSB wraps independently of the lower address bits. This allows the full/empty logic to differentiate between the two cases where read and write pointers would otherwise be identical.

### Full and Empty Flags

```verilog
assign empty = (read_ptr == write_ptr);
assign full  = ((write_ptr[ADDR_WIDTH] != read_ptr[ADDR_WIDTH]) &&
                (write_ptr[ADDR_WIDTH-1:0] == read_ptr[ADDR_WIDTH-1:0]));
```

- **Empty:** Both pointers are completely equal - same MSB, same lower bits.
- **Full:** Lower bits are equal but MSBs differ - write pointer has lapped the read pointer exactly once.

### Overflow and Underflow Protection

- Write operation is gated by `~full` - prevents overwriting valid data.
- Read operation is gated by `~empty` - prevents reading from an empty FIFO.

---

## RTL Source

### `fifo_sync.v`

```verilog
//RTL Code for SYNCHRONOUS FIFO
module fifo_sync #(
  parameter WIDTH = 8,
  parameter DEPTH = 16                      //Depth should be power of 2
)(
  input clk,
  input reset,
  input read_en,
  input [(WIDTH-1):0] data_in,
  input write_en,
  output empty,
  output full,
  output reg [(WIDTH-1):0] data_out
);
  localparam ADDR_WIDTH = $clog2(DEPTH);    //$clog2 calculates the number of bits required to represent the value
  //Creating Memory
  reg [(WIDTH-1):0] memory [0:(DEPTH-1)];
  //Creating Pointers
  reg [(ADDR_WIDTH):0] read_ptr;            //not ADDR_WIDTH-1:0 as because we are using a extra bit to check overflow and full condition  
  reg [(ADDR_WIDTH):0] write_ptr;           //not ADDR_WIDTH-1:0 as because we are using a extra bit to check overflow and full condition
  //Sequential block
  always @(posedge clk) begin
    if(reset) begin
      write_ptr <= 0;
      read_ptr <= 0;
    end
    else begin 
      //Write
      if(write_en && ~full) begin           //Overflow protection logic ~full
        memory[write_ptr[(ADDR_WIDTH-1):0]] <= data_in;
        write_ptr <= write_ptr + 1'b1;
      end
      //Read
      if(read_en && ~empty) begin          //Underflow protection logic ~empty
        data_out <= memory[read_ptr[(ADDR_WIDTH-1):0]];
        read_ptr <= read_ptr + 1'b1;
      end 
    end
  end
  //Assigning Empty and Full Flags
  assign empty = (read_ptr == write_ptr);
  assign full = ((write_ptr[ADDR_WIDTH] != read_ptr[ADDR_WIDTH]) && 
                 (write_ptr[(ADDR_WIDTH-1):0]) == read_ptr[(ADDR_WIDTH-1):0]);
endmodule
```

---

## Testbench: `fifo_sync_tb.v`

### Verification Strategy

The testbench uses a self-checking approach with reusable tasks. Each read operation automatically compares the received data against the expected value and reports PASS or FAIL to the console.

### Test Cases

| Test | Description |
|------|-------------|
| Basic Write/Read | Write 3 bytes (AB, CD, EF), read back and verify in order |
| Full Flag | Write 16 entries, verify `full` flag asserts |
| Empty Flag | Read all 16 entries, verify `empty` flag asserts |

### Tasks

**`write_data(val)`** - Asserts `write_en` for one clock cycle and writes `val` into the FIFO.

**`read_check_data(expected_val)`** - Asserts `read_en` for one clock cycle, waits for registered output to settle, then compares `data_out` against `expected_val` and prints PASS or FAIL.

### Testbench Source

```verilog
//Self Checking Testbench for Synchronous FIFO
`timescale 1ns/1ns
module fifo_sync_tb();
  //1. Signal intergration
  localparam WIDTH = 8;
  localparam DEPTH = 16;
  reg clk;
  reg reset;
  reg read_en;
  reg [(WIDTH-1):0] data_in;
  reg write_en;
  wire empty;
  wire full;
  wire [(WIDTH-1):0] data_out;
  //2. DUT instantiation
  fifo_sync #(.WIDTH(WIDTH),.DEPTH(DEPTH)) dut(.clk(clk),.reset(reset),.read_en(read_en),
                                               .data_in(data_in),.write_en(write_en),
                                               .empty(empty),.full(full),.data_out(data_out));
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  //4. Tasks
  //Task to write data into FIFO
  task write_data(input[(WIDTH-1):0] val);
    begin
      @(posedge clk);
      write_en <= 1'b1;
      data_in <= val;
      @(posedge clk);
      write_en <= 1'b0;
    end
  endtask

  //Task to read data and verify whether it match the expectation
  task read_check_data(input [(WIDTH-1):0] expected_val);
    begin
      @(posedge clk);
      read_en <= 1'b1;
      @(posedge clk);
      read_en <= 1'b0;
      @(posedge clk);
      if(data_out != expected_val)
        $display("[FAIL] Data mismatch! Expected: %h, Got: %h at time %t, FULL: %h, EMPTY: %h",expected_val,data_out,$time,full,empty);
      else
        $display("[PASS] Success! Verified data: %h, FULL: %h, EMPTY: %h",data_out,full,empty);
    end
  endtask
  
  //5. Waveform and Stimulus
  integer i;
  initial begin
    //Waveform
    $dumpfile("fifo_sync_tb.vcd");
    $dumpvars(0,fifo_sync_tb);
    //Stimulus
    reset=1; 
    read_en=0; 
    write_en=0; 
    data_in=0;
    repeat(2) @(posedge clk);     //Holding reset for 2 clock cycles
    reset=0;
    //Write operation
    $display("---Starting Write Operations---");
    write_data(8'hAB);
    write_data(8'hCD);
    write_data(8'hEF);
    
    //Read operation
    $display("---Starting Read Operation---");
    read_check_data(8'hAB);
    read_check_data(8'hCD);
    read_check_data(8'hEF);
    
    reset = 1'b1;
    repeat(2) @(posedge clk);
    reset = 1'b0;
    
    //Full flag testing
    $display("---Testing Full & Empty Condition---");
    for(i=0;i<DEPTH;i=i+1)
      write_data(i);
    @(posedge clk);
    if(full == 1'b1)
      $display("[PASS] FULL Flag Active, FIFO is FULL.");
    else
      $display("[FAIL] FULL Flag NOT Active but FIFO is FULL.");
    #20;
    //Empty flag testing
    for(i=0;i<DEPTH;i=i+1)
      read_check_data(i);
    @(posedge clk);
    if(empty == 1'b1)
      $display("[PASS] EMPTY Flag Active, FIFO is EMPTY.");
    else
      $display("[FAIL] EMPTY Flag NOT Active but FIFO is EMPTY.");
    #20;
    $finish;
  end
endmodule
```

---

## Expected Simulation Output

```
---Starting Write Operations---
---Starting Read Operation---
[PASS] Success! Verified data: ab
[PASS] Success! Verified data: cd
[PASS] Success! Verified data: ef
---Testing Full & Empty Condition---
[PASS] FULL Flag Active, FIFO is FULL.
[PASS] Success! Verified data: 00
[PASS] Success! Verified data: 01
[PASS] Success! Verified data: 02
...
[PASS] Success! Verified data: 0f
[PASS] EMPTY Flag Active, FIFO is EMPTY.
```

---

## Simulation

<img width="1026" height="763" alt="image" src="https://github.com/user-attachments/assets/9aa028c6-892d-4b39-9e3a-f0918e8d4905" />

<img width="1919" height="520" alt="image" src="https://github.com/user-attachments/assets/2d18cd41-a12d-41b7-a57f-2e88cfb2dca0" />

Simulated using EDA Playground with Icarus Verilog / Verilator. Waveforms captured in VCD format and verified in GTKWave.

---

## Key Concepts Demonstrated

- Parameterized RTL design
- Circular buffer architecture
- Extra-bit pointer technique for full/empty detection
- Overflow and underflow protection
- Self-checking testbench with reusable tasks

## Author
Madhan M.P  
[![LinkedIn](https://shields.io)](https://linkedin.com/in/madhan-mp)
[![GitHub](https://shields.io)](https://github.com/mpmadhan)
