# Parity Checker

Parity is used for error detection in digital communication. A parity bit is
added to transmitted data so the receiver can detect if any single bit got
corrupted during transmission. This folder contains both the generator (transmitter
side) and checker (receiver side).

## Modules

### parity_generator
Takes 4-bit data and generates an even parity bit.
If the number of 1s in data is already even, parity = 0.
If odd, parity = 1 to make the total count even.

### parity_checker
Takes 4-bit data and the received parity bit, outputs an error flag.
If XOR of all 5 bits = 0 → no error.
If XOR of all 5 bits = 1 → error detected.

## Ports

### parity_generator
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| d | input | 4-bit | Data input |
| parity | output | 1-bit | Generated parity bit |

### parity_checker
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| d | input | 4-bit | Received data |
| parity | input | 1-bit | Received parity bit |
| error | output | 1-bit | 1 = error detected, 0 = no error |

## How It Works
```
Transmitter side (Generator):
parity = d[3] ^ d[2] ^ d[1] ^ d[0]

Receiver side (Checker):
error = d[3] ^ d[2] ^ d[1] ^ d[0] ^ parity
error = 0 → data received correctly
error = 1 → single bit error detected
```

## Example

| Data | 1s count | Parity | Explanation |
|------|----------|--------|-------------|
| 0000 | 0 (even) | 0 | No parity bit needed |
| 0001 | 1 (odd)  | 1 | Parity=1 makes total even |
| 0011 | 2 (even) | 0 | Already even |
| 0111 | 3 (odd)  | 1 | Parity=1 makes total even |
| 1111 | 4 (even) | 0 | Already even |

## Files

| File | Description |
|------|-------------|
| parity_generator.v | Generates even parity bit for 4-bit data |
| parity_generator_tb.v | Testbench covering all 16 data combinations |
| parity_checker.v | Detects single bit errors using parity |
| parity_checker_tb.v | Testbench covering all 32 combinations (16 data × 2 parity) |

## RTL Code

### parity_generator
```verilog
//RTL Code for 4-Bit Parity Generator Circuit
module parity_generator(
  input [3:0] d,
  output parity
);
  //Generating Parity Bit (Output 0 if even no. of 1's)
  assign parity = (d[3] ^ d[2] ^ d[1] ^ d[0]);
endmodule
```

### parity_checker
```verilog
//RTL Code for 4-bit Parity Checker
module parity_checker(
  input [3:0] d,
  input parity,
  output error
);
  assign error = (d[3]^d[2]^d[1]^d[0]^parity);
  //if error = 1, then error in data
endmodule
```

## Testbench

### parity_generator
```verilog
//Testbench for 4-Bit Parity Generator
`timescale 1ns/1ps
module parity_generator_tb();
  //1. Signal declaration
  reg [3:0] d;
  wire parity;
  integer i;
  //2. DUT instantiation
  parity_generator dut(.d(d),.parity(parity));
  //3. waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile ("parity_generator_tb.vcd");
    $dumpvars (0,parity_generator_tb);
    //3.2 Display
    $display("Time |  D  | Parity");
    $display("-----|-----|-------");
    //3.3 Stimulus
    for (i=0;i<16;i=i+1) begin
      d=i; #10;
    end
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %4b | %b",$time,d,parity);
  end
endmodule
```

### parity_checker
```verilog
//Testbench for 4-Bit Parity Checker
`timescale 1ns/1ps
module parity_checker_tb();
  //1. Signal Declaration
  reg [3:0] d;
  reg parity;
  wire error;
  integer i,j;
  //2. Dut Instantiation
  parity_checker dut(.d(d),.parity(parity),.error(error));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("parity_checker_tb.vcd");
    $dumpvars(0,parity_checker_tb);
    //3.2 Display
    $display("Time |  D  Parity | Error");
    $display("-----|------------|------");
    //3.3 Stimulus
    for(i=0;i<16;i=i+1) begin
      d = i;
      for(j=0;j<2;j=j+1) begin
        parity = j; #10;
      end
    end
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %4b  %b | %b",$time,d,parity,error);
  end
endmodule
```

## Simulation

### parity_generator

<img width="776" height="568" alt="image" src="https://github.com/user-attachments/assets/229437ae-5078-40a2-aa96-f46c62672597" />

<img width="1912" height="381" alt="image" src="https://github.com/user-attachments/assets/ff7b9b48-7299-4d75-ba71-0df06da9d4f0" />

### parity_checker

<img width="705" height="563" alt="image" src="https://github.com/user-attachments/assets/c6c048a3-e5d0-4b58-b12a-a62999a6b194" /> <img width="612" height="558" alt="image" src="https://github.com/user-attachments/assets/11d58700-701a-42bd-9aef-9b6bcc7dfe51" />


<img width="1919" height="404" alt="image" src="https://github.com/user-attachments/assets/0ef929e9-71d0-464d-9caf-2dc0d777b7db" />

Simulated using EDA Playground. Generator verified across all 16 data combinations.
Checker verified across all 32 combinations - error detection confirmed.
