# Comparator

A Comparator compares two numbers and outputs 
whether A is equal to, greater than, or less than B. 

## Modules

### comparator_1bit - 1-bit Comparator
Compares two single bits using gate-level logic.

### comparator_4bit - 4-bit Comparator
Compares two 4-bit numbers using Verilog comparison operators.

## Ports

### comparator_1bit
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| a, b | input | 1-bit | Bits to compare |
| eq | output | 1-bit | 1 if A == B |
| gt | output | 1-bit | 1 if A > B |
| lt | output | 1-bit | 1 if A < B |

### comparator_4bit
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| a, b | input | 4-bit | Numbers to compare |
| eq | output | 1-bit | 1 if A == B |
| gt | output | 1-bit | 1 if A > B |
| lt | output | 1-bit | 1 if A < B |

## Truth Table

### comparator_1bit
| A | B | A>B | A=B | A<B |
|---|---|-----|-----|-----|
| 0 | 0 |  0  |  1  |  0  |
| 0 | 1 |  0  |  0  |  1  |
| 1 | 0 |  1  |  0  |  0  |
| 1 | 1 |  0  |  1  |  0  |

## Logic

### comparator_1bit
```
eq = ~(A ^ B)
gt =  A & ~B
lt = ~A &  B
```

### comparator_4bit
```
eq = (A == B)
gt = (A > B)
lt = (A < B)
```

## Files

| File | Description |
|------|-------------|
| comparator_1bit.v | 1-bit Comparator using gate-level logic |
| comparator_1bit_tb.v | Testbench with all 4 combinations |
| comparator_4bit.v | 4-bit Comparator using comparison operators |
| comparator_4bit_tb.v | Testbench with all 256 combinations via nested for loop |

## RTL Code

### comparator_1bit
```verilog
//RTL Code for 1-bit Comparator
/*
A B | A>B A=B A<B
0 0 |  0   1   0
0 1 |  0   0   1
1 0 |  1   0   0
1 1 |  0   1   0
*/
module comparator_1bit(
  input a,b,
  output eq,gt,lt
);
  assign eq = ~(a^b);
  assign gt = (a&(~b));
  assign lt = ((~a)&b);
endmodule
```

### comparator_4bit
```verilog
//RTL Code for 4-Bit Comparator
module comparator_4bit(
  input [3:0] a,b,
  output eq,gt,lt
);
  assign eq = (a==b);
  assign gt = (a > b);
  assign lt = (a < b);
endmodule
  
```

## Testbench

### comparator_1bit
```verilog
//Testbench for 1-Bit Comparator
`timescale 1ns/1ps
module comparator_1bit_tb();
  //1. Signal Declaration
  reg a,b;
  wire eq,gt,lt;
  //2. DUT instantitation
  comparator_1bit dut(.a(a),.b(b),.eq(eq),.gt(gt),.lt(lt));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile ("comparator_1bit_tb.vcd");
    $dumpvars (0,comparator_1bit_tb);
    //3.2 Display
    $display ("Time | A B | A>B A=B A<B");
    $display ("-----|-----|------------");
    //3.3 Stimulus
    a=0; b=0; #10;
    a=0; b=1; #10;
    a=1; b=0; #10;
    a=1; b=1; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %b | %b %b %b",$time,a,b,gt,eq,lt);
  end
endmodule
```

### comparator_4bit
```verilog
//Testbench for 4-Bit Comparator
`timescale 1ns/1ps
module comparator_4bit_tb();
  //1. Signal Declaration
  reg [3:0] a,b;
  wire eq,gt,lt;
  integer i,j;
  //2. DUT instantiation
  comparator_4bit dut(.a(a),.b(b),.eq(eq),.gt(gt),.lt(lt));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("comparator_4bit_tb.vcd");
    $dumpvars(0,comparator_4bit_tb);
    //3.2 Display
    $display("Time |  A   B  | A>B A=B A<B ");
    $display("-----|---------|-------------");
    //3.3 Stimulus
    for(i=0;i<16;i=i+1) begin
      a = i;
      for(j=0;j<16;j=j+1) begin
        b = j; #10;
      end
    end
    $finish;  
  end
  //4. Observation
  initial begin
    $monitor("%4t | %4b  %4b  | %b %b %b",$time,a,b,gt,eq,lt);
  end
endmodule
      
```

## Simulation

### comparator_1bit

<img width="418" height="382" alt="image" src="https://github.com/user-attachments/assets/452a4910-e114-4c13-a460-58c31fa5de8f" />

<img width="1915" height="341" alt="image" src="https://github.com/user-attachments/assets/4995b7cd-9b71-4911-93ae-b52b30d5a470" />

### comparator_4bit

<img width="250" height="450" alt="image" src="https://github.com/user-attachments/assets/7861c377-6e4e-4dc9-a368-c096f8adb940" /> <img width="250" height="300" alt="image" src="https://github.com/user-attachments/assets/030734ac-491b-4621-a8c7-1e1848f00c29" /> 

<img width="1911" height="566" alt="image" src="https://github.com/user-attachments/assets/eee0395a-59ca-45df-a3c0-60e4df576da9" />

Simulated using EDA Playground. All combinations verified including
equal, greater than, and less than cases.
