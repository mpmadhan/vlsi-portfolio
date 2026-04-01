# SR Flip Flop

An SR Flip Flop has two inputs - S (Set) and R (Reset). It is the simplest
form of a clocked flip flop. The key limitation of SR FF is the invalid state
when both S and R are high simultaneously - this ambiguity is what motivated
the design of the JK Flip Flop.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| s | input | 1-bit | Set input |
| r | input | 1-bit | Reset input |
| reset | input | 1-bit | Active high synchronous reset |
| q | output | 1-bit | Registered output |

## Truth Table

| S | R | Q(next) | Action |
|---|---|---------|--------|
| 0 | 0 | Q | Hold |
| 0 | 1 | 0 | Reset |
| 1 | 0 | 1 | Set |
| 1 | 1 | x | Invalid |

## Logic
```
S R Q | Qnext
------|------
0 0 0 |   0
0 0 1 |   1
0 1 0 |   0
0 1 1 |   0
1 0 0 |   1
1 0 1 |   1
1 1 0 |   X
1 1 1 |   X

Qnext = S | (R'.Q)
```

## Files

| File | Description |
|------|-------------|
| srff.v | SR FF with synchronous reset and invalid state handling |
| srff_tb.v | Testbench covering all SR states including invalid |

## RTL Code
```verilog
//RTL Code for SR Flip Flop
/*
S R Q | Qnext
------|------
0 0 0 |   0
0 0 1 |   1
0 1 0 |   0
0 1 1 |   0
1 0 0 |   1
1 0 1 |   1
1 1 0 |   X
1 1 1 |   X
Qnext = S | (R'.Q)
*/
module srff(
  input clk, s, r, reset,
  output reg q
);
  always @(posedge clk) begin
    if(reset)
      q <= 0;
    else if(s&r)
      q <= 1'bx;
    else
      q <= s|((~r)&q);
  end
endmodule
```

## Testbench
```verilog
//Testbench for SR Flip Flop
`timescale 1ns/1ps
module srff_tb();
  //1. Signal Declaration
  reg clk, s, r, reset;
  wire q;
  //2. DUT instantiation
  srff dut(.clk(clk),.s(s),.r(r),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("srff_tb.vcd");
    $dumpvars(0,srff_tb);
    //4.2 Display
    $display("Time | Clk S R Rst | Q ");
    $display("-----|-------------|---");
    //4.3 Stimulus
    s=0;r=0;reset=1; #10; //Reset High
    s=0;r=1;reset=0; #10; //Reset low and SR reset
    s=1;r=0;reset=0; #10; //SR Set
    s=1;r=0;reset=1; #10; //Reset high
    s=1;r=0;reset=0; #10; //Reset low
    s=1;r=1;reset=0; #10; //Invalid condition
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b %b | %b",$time,clk,s,r,reset,q);
  end
endmodule
```

## Simulation

<img width="300" height="450" alt="image" src="https://github.com/user-attachments/assets/b44cdbe9-b412-4222-bce4-518489cabb45" />

<img width="1919" height="335" alt="image" src="https://github.com/user-attachments/assets/2ed832e4-8244-4e0c-943b-3312c0193027" />

Simulated using EDA Playground. All states verified -
Hold, Set, Reset and Invalid condition confirmed.
