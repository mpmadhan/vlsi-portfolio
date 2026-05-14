# Full Adder

A Full Adder extends the Half Adder by accepting a Carry In - making it possible
to chain multiple adders together for multi-bit addition. It adds three bits: A, B,
and Cin, and produces a Sum and Carry Out.

## Ports

| Port | Direction | Description |
|---|---|---|
| a | input | First input bit |
| b | input | Second input bit |
| cin | input | Carry In (from previous stage) |
| sum | output | XOR of a, b and cin |
| cout | output | Carry Out to next stage |

## Truth Table

| A | B | Cin | Sum | Cout |
|---|---|-----|-----|------|
| 0 | 0 |  0  |  0  |  0   |
| 0 | 0 |  1  |  1  |  0   |
| 0 | 1 |  0  |  1  |  0   |
| 0 | 1 |  1  |  0  |  1   |
| 1 | 0 |  0  |  1  |  0   |
| 1 | 0 |  1  |  0  |  1   |
| 1 | 1 |  0  |  0  |  1   |
| 1 | 1 |  1  |  1  |  1   |

## Logic
```
Sum  = A ^ B ^ Cin
Cout = (A & B) | (B & Cin) | (Cin & A)
```
## RTL Code
RTL Code that implements FA
```verilog
//RTL Code for Full Adder (2 inputs, 1 Cin)
module full_adder(
  input a, b, cin,
  output sum, cout
);
  assign sum = a^b^cin;
  assign cout = (a&b)|(b&cin)|(cin&a);
  //assign {cout,sum} = a+b+cin; also works
endmodule
```
  
RTL Code for FA using two HA
```verilog
//RTL Code that implements Full Adder using Half Adder
module fa_with_ha(
  input a, b, cin,
  output sum, cout
);
  wire sum1, carry1, carry2;
  half_adder ha1(.a(a), .b(b), .sum(sum1), .cout(carry1));
  half_adder ha2(.a(sum1), .b(cin), .sum(sum), .cout(carry2));
  assign cout = carry1 | carry2;
endmodule
```


## Testbench
Testbench for FA  
```verilog
//Testbench for Full Adder
`timescale 1ns/1ps
module full_adder_tb();
  //1. Signal declaration
  reg a, b, cin;
  wire sum, cout;
  //2. DUT instantiation
  full_adder dut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
  //3. Stimulus + Waveform
  initial begin
    //3.1 Waveform
    $dumpfile("full_adder_tb.vcd");
    $dumpvars(0,full_adder_tb);
    //3.2 Stimulus
    $display("Time | A B Cin | Sum  Cout |");
    $display("-----|---------|----------|");
    a=0; b=0; cin=0; #10;
    a=0; b=0; cin=1; #10;
    a=0; b=1; cin=0; #10;
    a=0; b=1; cin=1; #10;
    a=1; b=0; cin=0; #10;
    a=1; b=0; cin=1; #10;
    a=1; b=1; cin=0; #10;
    a=1; b=1; cin=1; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b   %b |", $time, a, b, cin, sum, cout);
  end
endmodule
```
Testbench for FA that uses two HAs  
```verilog
//Testbench for Full Adder
`timescale 1ns/1ps
module fa_with_ha_tb();
  //1. Signal declaration
  reg a, b, cin;
  wire sum, cout;
  //2. DUT instantiation
  fa_with_ha dut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
  //3. Stimulus + Waveform
  initial begin
    //3.1 Waveform
    $dumpfile("fa_with_ha_tb.vcd");
    $dumpvars(0,fa_with_ha_tb);
    //3.2 Stimulus
    $display("Time | A B Cin | Sum  Cout |");
    $display("-----|---------|----------|");
    a=0; b=0; cin=0; #10;
    a=0; b=0; cin=1; #10;
    a=0; b=1; cin=0; #10;
    a=0; b=1; cin=1; #10;
    a=1; b=0; cin=0; #10;
    a=1; b=0; cin=1; #10;
    a=1; b=1; cin=0; #10;
    a=1; b=1; cin=1; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b   %b |", $time, a, b, cin, sum, cout);
  end
endmodule
```
  
## Files

| File | Description |
|------|-------------|
| full_adder.v | RTL design (dataflow modeling) |
| full_adder_tb.v | Testbench with all 8 input combinations |
| fa_with_ha.v | RTL design (using two HA) |
| fa_with_ha_tb.v | Testbench for RTL Design that uses two HA|

## Simulation

<img width="1840" height="519" alt="image" src="https://github.com/user-attachments/assets/af5cee55-1adf-4d62-8155-ecf2cf4a300c" />

Simulated using EDA Playground. All 8 input combinations verified.
