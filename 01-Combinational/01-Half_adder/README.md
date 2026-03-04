# Half Adder

This circuit adds two single bits and gives a Sum and a Carry output.  

## Ports

| Port | Direction | Description |
|---|---|---|
| a | input | First input bit |
| b | input | Second input bit |
| sum | output | XOR of a and b |
| cout | output | AND of a and b (Carry Out) |

## Truth Table

| A | B | Sum | Cout |
|---|---|-----|------|
| 0 | 0 |  0  |  0   |
| 0 | 1 |  1  |  0   |
| 1 | 0 |  1  |  0   |
| 1 | 1 |  0  |  1   |

## Logic
```
Sum  = A ^ B
Cout = A & B
```
## RTL Code
```verilog
//RTL Code for Half Adder
module half_adder(
  input a,
  input b,
  output sum,
  output cout //Carry
);
  assign sum = a^b; 
  assign cout = a&b;
endmodule
```
## Testbench
```verilog
//Testbench for Half Adder
`timescale 1ns/1ps
module half_adder_tb();
  //1. Signal declaration
  reg a, b;
  wire sum, cout;
  //2. DUT instantiation
  half_adder dut(.a(a), .b(b), .sum(sum), .cout(cout));
  //3. Stimulus + Waveform
  initial begin
    //3.1 Waveform Generation
    $dumpfile("half_adder_tb.vcd");
    $dumpvars(0,half_adder_tb);
    //3.2 Stimulus
    $display("Time | A B | Sum Cout");
    $display("-----|-----|---------");
    a=0; b=0; #10;
    a=0; b=1; #10;
    a=1; b=0; #10;
    a=1; b=1; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %b |  %b   %b", $time, a, b, sum, cout);
  end
  
endmodule
```

## Files

| File | Description |
|------|-------------|
| half_adder.v | RTL design |
| half_adder_tb.v | Testbench with all 4 input combinations |

## Simulation
<img width="1837" height="504" alt="image" src="https://github.com/user-attachments/assets/65848ff1-1221-47c3-a458-9a908312b167" />

Simulated using EDA Playground. All 4 input combinations verified.
