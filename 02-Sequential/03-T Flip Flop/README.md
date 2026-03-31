# T Flip Flop

A T (Toggle) Flip Flop has a single input T. When T is low, the output holds
its current value. When T is high, the output toggles on every rising clock edge.
It is essentially a special case of the JK Flip Flop where J and K are tied
together (J=K=T).

T FFs are commonly used in frequency dividers and ripple counters - each T FF
in a chain divides the clock frequency by 2.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| t | input | 1-bit | Toggle input |
| reset | input | 1-bit | Active high synchronous reset |
| q | output | 1-bit | Registered output |

## Truth Table

| T | Q | Q(next) | Action |
|---|---|---------|--------|
| 0 | 0 |    0    | Hold |
| 0 | 1 |    1    | Hold |
| 1 | 0 |    1    | Toggle |
| 1 | 1 |    0    | Toggle |

## Logic
```
Qnext = T ^ Q

Derived from JK FF by setting J = K = T:
Qnext = (J & ~Q) | (~K & Q)
      = (T & ~Q) | (~T & Q)
      = T ^ Q
```

## Files

| File | Description |
|------|-------------|
| tff.v | T FF with synchronous reset |
| tff_tb.v | Testbench covering hold, toggle and reset behavior |

## RTL Code
```verilog
//RTL Code for T-Flip Flop
/*
T Q | Qnext
0 0 |  0
0 1 |  1
1 0 |  1
1 1 |  0
Qnext = T^Q
*/
module tff(
  input clk, t, reset,
  output reg q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else
      q<=(t^q);
  end
endmodule
```

## Testbench
```verilog
//Testbench for T Flip Flop
`timescale 1ns/1ps
module tff_tb();
  //1. Signal Declaration
  reg clk, t, reset;
  wire q;
  //2. DUT instantiation
  tff dut(.clk(clk),.t(t),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("tff_tb.vcd");
    $dumpvars(0,tff_tb);
    //4.2 Display
    $display(" Time | Clk T Rst | Q");
    $display("------|-----------|---");
    //4.3 Stimulus
    reset=1;t=0; #13; //Reset high
    t=1; #10;         //input high when reset high
    reset=0; #10;     //Reset low
    t=0; #10;         //input low
    t=1; #10;         //input high (output toggles)
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b",$time,clk,t,reset,q);
  end
endmodule
```

## Simulation

<img width="300" height="500" alt="image" src="https://github.com/user-attachments/assets/c16b0d40-996a-4e96-944b-39e4a75c3260" />

<img width="1916" height="314" alt="image" src="https://github.com/user-attachments/assets/864ac587-05b2-4de0-af84-bd185497a2f4" />

Simulated using EDA Playground. Hold and Toggle behavior verified.
Reset override confirmed.
