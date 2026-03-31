# D Flip Flop

A D Flip Flop is a 1-bit memory element that captures the value of input D
at the rising edge of the clock and holds it at output Q until the next rising
edge. It is the fundamental building block of all sequential circuits -
registers, counters, shift registers, and FSMs are all built from flip flops.

Two versions are implemented here - synchronous reset and asynchronous reset.

## Modules

### dff_sync - Synchronous Reset
Reset is sampled only at the rising edge of the clock.
The output Q is updated to 0 only when reset is high at a clock edge.

### dff_async - Asynchronous Reset
Reset is independent of the clock - as soon as reset goes high,
output Q immediately goes to 0 regardless of the clock state.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| d | input | 1-bit | Data input |
| reset | input | 1-bit | Active high reset |
| q | output | 1-bit | Registered output |

## Truth Table

| Clk | Reset | D | Q (next) |
|-----|-------|---|----------|
| ↑   |   1   | x |    0     |
| ↑   |   0   | 0 |    0     |
| ↑   |   0   | 1 |    1     |
| no edge | x | x | Q holds  |

x = don't care

Note: For dff_sync, reset is only checked at posedge clk.
For dff_async, reset takes effect immediately when high,
independent of the clock.

## Key Difference

| | dff_sync | dff_async |
|---|---|---|
| Reset takes effect | On next rising clock edge | Immediately |
| Sensitivity list | `@(posedge clk)` | `@(posedge clk or posedge reset)` |
| Used when | Reset can wait for clock | Instant reset is required |

## Files

| File | Description |
|------|-------------|
| dff_sync.v | D FF with synchronous reset |
| dff_sync_tb.v | Testbench for synchronous D FF |
| dff_async.v | D FF with asynchronous reset |
| dff_async_tb.v | Testbench for asynchronous D FF |

## RTL Code

### dff_sync
```verilog
//RTL Code for Synchronous D-Flip flop
module dff_sync(
  input clk, d, reset,
  output reg q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else
      q<=d;
  end
endmodule
```

### dff_async
```verilog
//RTL Code for Asynchronous D-Flip Flop
module dff_async(
  input clk,d,reset,
  output reg q
);
  always @(posedge clk or posedge reset) begin
    if(reset)
      q<=0;
    else
      q<=d;
  end
endmodule
```

## Testbench

### dff_sync
```verilog
//Testbench for Synchronous D-Flip Flop
`timescale 1ns/1ps
module dff_sync_tb();
  //1. Signal Declaration
  reg clk,d,reset;
  wire q;
  //2. DUT instantiation
  dff_sync dut(.clk(clk),.d(d),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("dff_sync_tb.vcd");
    $dumpvars(0,dff_sync_tb);
    //4.2 Display
    $display(" Time | Clk D Reset | Q ");
    $display("------|-------------|----");
    //4.3 Stimulus
    reset=1; d=0;     //applying reset
    #12 reset=0;      //removing reset
    #10 d=1;          //applying input
    #10 reset=1;      //applying reset when input is high
    #10 reset=0;      //removing reset
    #10 d=0;          //applying input to low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b  %b  | %b ",$time,clk,d,reset,q);
  end
endmodule
```

### dff_async
```verilog
//Testbench for Asynchronous D-Flip Flop
`timescale 1ns/1ps
module dff_async_tb();
  //1. Signal Declaration
  reg clk,d,reset;
  wire q;
  //2. DUT instantiation
  dff_async dut(.clk(clk),.d(d),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("dff_async_tb.vcd");
    $dumpvars(0,dff_async_tb);
    //4.2 Display
    $display(" Time | Clk D Rst | Q ");
    $display("------|-----------|---");
    //4.3 Stimulus
    reset=1; d=0;     //applying reset
    #13 reset=0;d=1;  //Removing reset and input high
    #10 reset=1;      //applying reset
    #10 reset=0;      //removing reset
    #10 d=0;          //input low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b",$time,clk,d,reset,q);
  end
endmodule
```

## Simulation

### dff_sync

<img width="521" height="428" alt="image" src="https://github.com/user-attachments/assets/53abfbab-39e7-43d7-b30c-5ccb3ca866df" />

<img width="1907" height="327" alt="image" src="https://github.com/user-attachments/assets/e819c2da-e276-4de5-96be-5b1381f63ab7" />

### dff_async

<img width="675" height="479" alt="image" src="https://github.com/user-attachments/assets/38a39ce4-68a7-4bd4-b38f-521ef9a5546f" />

<img width="1913" height="317" alt="image" src="https://github.com/user-attachments/assets/75ac7911-e6fd-43ad-8437-c1cec5fa5c24" />

Simulated using EDA Playground. Reset behavior verified for both
synchronous and asynchronous versions. Output Q confirmed to hold
value between clock edges.
