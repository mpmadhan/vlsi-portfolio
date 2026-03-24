# Ripple Carry Adder

A Ripple Carry Adder chains multiple Full Adders to add two multi-bit numbers.
The carry out of each stage feeds into the carry in of the next - rippling from
LSB to MSB. Two implementations are provided here.

## Modules

### rca_4bit — Structural (4-bit)
Built by instantiating four Full Adders explicitly. Shows exactly how carry
propagates through each bit position.

### rca_nbit — Parameterized (N-bit)
A single-line dataflow implementation that works for any bit width.
Default width is 4 - change the parameter to scale to 8, 16, or 32 bits.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| a | input | N-bit | First operand |
| b | input | N-bit | Second operand |
| cin | input | 1-bit | Initial carry in |
| sum | output | N-bit | Addition result |
| cout | output | 1-bit | Carry out (overflow indicator) |

## How It Works
```
FA0: A[0] + B[0] + Cin   → Sum[0], C1
FA1: A[1] + B[1] + C1    → Sum[1], C2
FA2: A[2] + B[2] + C2    → Sum[2], C3
FA3: A[3] + B[3] + C3    → Sum[3], Cout
```

## Example Calculations

| A | B | Cin | Sum | Cout | Note |
|---|---|-----|-----|------|------|
| 0000 | 0000 | 0 | 0000 | 0 | 0+0=0 |
| 0011 | 0100 | 1 | 1000 | 0 | 3+4+1=8 |
| 0101 | 1010 | 1 | 0000 | 1 | 5+10+1=16 overflow |
| 1111 | 1111 | 1 | 1111 | 1 | 15+15+1=31 overflow |

## Files

| File | Description |
|------|-------------|
| rca_4bit.v | 4-bit structural RCA using 4 Full Adder instances |
| rca_4bit_tb.v | Testbench with test cases including overflow |
| rca_nbit.v | Parameterized N-bit RCA using single assign statement |
| rca_nbit_tb.v | Testbench using localparam for configurable width |

## RTL Code
RTL Code for 4-Bit RCA
```verilog
//RTL Code for 4-bit Ripple Carry Adder
module rca_4bit(
  input [3:0] a,b,
  input cin,
  output [3:0] sum,
  output cout
);
  wire c1,c2,c3;
  //With 4 full adder instantiations
  full_adder fa0(.a(a[0]),.b(b[0]),.cin(cin),.sum(sum[0]),.cout(c1));
  full_adder fa1(.a(a[1]),.b(b[1]),.cin(c1),.sum(sum[1]),.cout(c2));
  full_adder fa2(.a(a[2]),.b(b[2]),.cin(c2),.sum(sum[2]),.cout(c3));
  full_adder fa3(.a(a[3]),.b(b[3]),.cin(c3),.sum(sum[3]),.cout(cout));
  //Without Full Adder instantiations
  //assign {cout,sum} = a+b+cin; 
endmodule
```

RTL Code for Parameterized N-Bit RCA
```verilog
//RTL Code for N-Bit Ripple Carry Adder
module rca_nbit #(parameter WIDTH = 4)(
  input [(WIDTH-1):0] a,b,
  input cin,
  output [(WIDTH-1):0] sum,
  output cout
);
  assign {cout,sum} = a + b + cin;
endmodule
```

## Testbench
Testbench for 4-Bit RCA
```verilog
//Testbench for 4-bit Ripple Carry Adder
`timescale 1ns/1ps
module rca_4bit_tb();
  //1.Signal declaration
  reg [3:0] a,b;
  reg cin;
  wire [3:0] sum;
  wire cout;
  //2.DUT instantiation
  rca_4bit dut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
  //3.Stimulus and Waveform
  initial begin
    //Waveform analysis
    $dumpfile("rca_4bit_tb.vcd");
    $dumpvars(0,rca_4bit_tb);
    //Stimulus
    $display("| Time | A B Cin | Sum Cout |");
    $display("|------|---------|----------|");
    a=4'd0;b=4'd0;cin=0; #10; //0+0+0 = 0
    a=4'd3;b=4'd4;cin=1; #10; //3+4+1 = 8
    a=4'd5;b=4'd10;cin=1; #10; //5+10+1 = 16 overflow
    a=4'd15;b=4'd15;cin=1; #10; //15+15+1 = 31 overflow
    $finish;
  end
  //4.Observation
  initial begin
    $monitor("| %4t | %4b %4b %b | %4b %b |",$time,a,b,cin,sum,cout);
  end
endmodule
```

Testbench for N-Bit Parameterized RCA
```verilog
//Testbench for N-bit Ripple Carry Adder
`timescale 1ns/1ps
module rca_nbit_tb();
  //1. Signal declaration
  localparam WIDTH = 4;

  reg [(WIDTH-1):0] a,b;
  reg cin;
  wire [(WIDTH-1):0] sum;
  wire cout;
  //2. DUT instantiation
  rca_nbit #(.WIDTH(WIDTH)) dut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("rca_nbit_tb.vcd");
    $dumpvars(0,rca_nbit_tb);
    //3.2 Stimulus
    $display("| T | A B Cin | Sum Cout |");
    $display("|---|---------|----------|");

    a=4'd0;b=4'd0;cin=0; #10; //0+0+0 = 0
    a=4'd3;b=4'd4;cin=1; #10; //3+4+1 = 8
    a=4'd5;b=4'd10;cin=1; #10; //5+10+1 = 16 overflow
    a=4'd15;b=4'd15;cin=1; #10; //15+15+1 = 31 overflow
    $finish;
  end
  //4.Observation
  initial begin
    $monitor("| %4t | %4b %4b %b | %4b %b |",$time,a,b,cin,sum,cout);
  end
endmodule
```

## Simulation


Simulated using EDA Playground. Overflow behavior verified via cout signal.
