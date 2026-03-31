# JK Flip Flop

A JK Flip Flop is an improved version of the SR Flip Flop that eliminates
the invalid state problem. It has two inputs - J (Set) and K (Reset) - and
introduces a toggle state when both J and K are high simultaneously, which
makes it more versatile than the SR FF.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| j | input | 1-bit | Set input |
| k | input | 1-bit | Reset input |
| reset | input | 1-bit | Active high synchronous reset |
| q | output | 1-bit | Registered output |

## Truth Table

| J | K | Q(next) | Action |
|---|---|---------|--------|
| 0 | 0 | Q | Hold |
| 0 | 1 | 0 | Reset |
| 1 | 0 | 1 | Set |
| 1 | 1 | ~Q | Toggle |

## Logic Derivation
```
J K Q | Qnext
------|------
0 0 0 |   0
0 0 1 |   1
0 1 0 |   0
0 1 1 |   0
1 0 0 |   1
1 0 1 |   1
1 1 0 |   1
1 1 1 |   0

Qnext = (J'K'Q)|(JK'Q')|(JK'Q)|(JKQ')
      = K'Q(J|J') | JQ'(K'|K)
      = J.Q' | K'.Q
```

## Files

| File | Description |
|------|-------------|
| jk_ff.v | JK FF with synchronous reset |
| jk_ff_tb.v | Testbench covering all 4 JK states |

## RTL Code
```verilog
//RTL Code for JK Flip Flop
/*
J K | Q 
0 0 | Q
0 1 | 0
1 0 | 1
1 1 | Q'
J K Q | Qnext
------|------
0 0 0 |   0
0 0 1 |   1
0 1 0 |   0
0 1 1 |   0
1 0 0 |   1
1 0 1 |   1
1 1 0 |   1
1 1 1 |   0
Qnext = (J'K'Q)|(JK'Q')|(JK'Q)|(JKQ')
      = K'Q(J|J') | JQ'(K'|K)
      = J.Q' | K'.Q
*/
module jk_ff(
  input clk, j, k, reset,
  output reg q
);
  always @(posedge clk) begin
    if(reset)
      q <= 0;
    else
      q <= (j&(~q))|((~k)&q);
  end
endmodule
```

## Testbench
```verilog
//Testbench for JK Flip flop
`timescale 1ns/1ps
module jk_ff_tb();
  //1. Signal Declaration
  reg clk, j, k, reset;
  wire q;
  //2. DUT Instantiation
  jk_ff dut(.clk(clk),.j(j),.k(k),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("jk_ff_tb.vcd");
    $dumpvars(0,jk_ff_tb);
    //4.2 Display
    $display("Time | J K Rst | Q");
    $display("-----|---------|---");
    //4.3 Stimulus
    j=0;k=0;reset=1; #12;  //reset high
    j=1;k=0; #10;           //set but reset high
    reset=0; #10;           //reset removed
    j=0;k=0; #10;           //memory
    j=0;k=1; #10;           //reset
    j=1;k=1; #10;           //toggle
    j=0;k=0; #10;           //memory
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b",$time,j,k,reset,q);
  end
endmodule
```

## Simulation

<img width="400" height="500" alt="image" src="https://github.com/user-attachments/assets/8119ef90-df67-48b9-a5fe-abab34e82184" />

<img width="1919" height="365" alt="image" src="https://github.com/user-attachments/assets/e1c081a1-e6b8-4795-94b7-e1ad6e8b1e63" />

Simulated using EDA Playground. All four states verified -
Hold, Set, Reset and Toggle.
