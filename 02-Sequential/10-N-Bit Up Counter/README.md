# Up Counter

An Up Counter increments its output by 1 on every rising clock edge.
It counts from 0 to 2ᴺ-1 and automatically rolls back to 0 after
reaching the maximum value. It is one of the most fundamental sequential
circuits used in timing, sequencing, and address generation.

## Module

### upcounter_nbit - N-bit Up Counter
Parameterized N-bit up counter with enable and synchronous reset.
Default width is 4. Counting pauses when enable is low.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| reset | input | 1-bit | Active high synchronous reset |
| enable | input | 1-bit | 1 = count, 0 = hold |
| q | output | N-bit | Counter output |

## How It Works
```
On every posedge clk:
if reset  → q = 0
if enable → q = q + 1
else      → q holds (no change)
Counter rolls over from 2ᴺ-1 back to 0 automatically.
```
## Files

| File | Description |
|------|-------------|
| upcounter_nbit.v | Parameterized N-bit up counter |
| upcounter_nbit_tb.v | Testbench covering full count cycle and rollover |

## RTL Code

```verilog
//RTL Code for N-Bit UP- Counter
module upcounter_nbit #(parameter N=4)(
  input clk, reset, enable,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else if(enable)
      q <= q+1;
    //if reset and enable is 0, count holds
  end
endmodule
```

## Testbench

```verilog
//Testbench for N-Bit UP Counter
`timescale 1ns/1ps
module upcounter_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk, reset, enable;
  wire [(N-1):0] q;
  //2. DUT instantiation
  upcounter_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.enable(enable),.q(q));
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform & Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("upcounter_nbit_tb.vcd");
    $dumpvars(0,upcounter_nbit_tb);
    //4.2 Display
    $display(" Time | Rst En |   Q   ");
    $display("------|--------|-------");
    //4.3 Stimulus
    reset=1;enable=0; #13; //Reset High
    enable=1; #10;         //Enable high but reset high
    reset=0; #10;          //Reset low
    repeat(1<<N)           //2^N cycles
      @(posedge clk);
    repeat(3)
      @(posedge clk);      //To check whether it is reverting back to 0000 after all bits high
    reset=1; #20;
    reset=0; #10;
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,reset,enable,q);
  end
endmodule
```

## Simulation

<img width="350" height="500" alt="image" src="https://github.com/user-attachments/assets/2eca94e3-645b-4a58-855c-d2d8957a3781" />

<img width="1919" height="499" alt="image" src="https://github.com/user-attachments/assets/acbb4a6c-6503-4970-beda-e1904e804365" />

Simulated using EDA Playground. Full count cycle verified from 0 to 2ᴺ-1.
Rollover to 0 confirmed. Reset and enable behavior verified.
