# Down Counter

A Down Counter decrements its output by 1 on every rising clock edge.
It counts down from 2ᴺ-1 to 0 and automatically wraps back to 2ᴺ-1
after reaching 0. Used in countdown timers, watchdog circuits, and
address decrement operations.

## Module

### downcounter_nbit - N-bit Down Counter
Parameterized N-bit down counter with enable and synchronous reset.
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
if enable → q = q - 1
else      → q holds (no change)
Counter wraps from 0 back to 2ᴺ-1 automatically.
```
## Files

| File | Description |
|------|-------------|
| downcounter_nbit.v | Parameterized N-bit down counter |
| downcounter_nbit_tb.v | Testbench covering full count cycle and wraparound |

## RTL Code

```verilog
//RTL Code for N-Bit DOWN- Counter
module downcounter_nbit #(parameter N=4)(
  input clk, reset, enable,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else if(enable)
      q <= q-1;
    //if reset and enable is 0, count holds
  end
endmodule
```

## Testbench

```verilog
//Testbench for N-Bit DOWN Counter
`timescale 1ns/1ps
module downcounter_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk, reset, enable;
  wire [(N-1):0] q;
  //2. DUT instantiation
  downcounter_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.enable(enable),.q(q));
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform & Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("downcounter_nbit_tb.vcd");
    $dumpvars(0,downcounter_nbit_tb);
    //4.2 Display
    $display(" Time | Rst En |   Q   ");
    $display("------|--------|-------");
    //4.3 Stimulus
    reset=1;enable=0; #13; //Reset High
    enable=1; #10;         //Enable high but reset high
    reset=0; #10;          //Reset low, counter wraps from 0 to 2^N-1
    repeat(1<<N)           //2^N cycles
      @(posedge clk);
    repeat(3)
      @(posedge clk);
    reset=1; #20;          //Checking reset case
    reset=0; #10;          //Removing reset
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,reset,enable,q);
  end
endmodule
```

## Simulation

<img width="400" height="550" alt="image" src="https://github.com/user-attachments/assets/4cd9c521-b36a-4e89-8b66-5ab3af64e0d4" />

<img width="1913" height="469" alt="image" src="https://github.com/user-attachments/assets/e8bf8e0b-af0a-4dcb-a496-6bc844888c83" />

Simulated using EDA Playground. Counter verified to decrement from
2ᴺ-1 to 0 and wrap around. Reset and enable behavior confirmed.
