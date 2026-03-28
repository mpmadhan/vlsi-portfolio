# Encoder

An Encoder converts an active input line into its binary representation.
It takes 2ⁿ input lines (only one is active at a time) and it produces an n-bit
binary code output indicating which input is currently active.

## Modules

### encoder_4x2 - 4:2 Encoder
4 inputs, 2-bit binary output.
Implemented using OR gate assign statements.

### encoder_8x3 - 8:3 Encoder
8 inputs, 3-bit binary output.
Implemented using OR gate assign statements.

## Ports

### encoder_4x2
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| i | input | 4-bit | One-hot input lines |
| y | output | 2-bit | Binary encoded output |

### encoder_8x3
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| in | input | 8-bit | One-hot input lines |
| out | output | 3-bit | Binary encoded output |

## Truth Table

### encoder_4x2
| I3 | I2 | I1 | I0 | Y1 | Y0 |
|----|----|----|----|----|-----|
| 0  | 0  | 0  | 1  | 0  | 0  |
| 0  | 0  | 1  | 0  | 0  | 1  |
| 0  | 1  | 0  | 0  | 1  | 0  |
| 1  | 0  | 0  | 0  | 1  | 1  |

### encoder_8x3
| I7 | I6 | I5 | I4 | I3 | I2 | I1 | I0 | Y2 | Y1 | Y0 |
|----|----|----|----|----|----|----|----|----|----|----|
| 0  | 0  | 0  | 0  | 0  | 0  | 0  | 1  | 0  | 0  | 0  |
| 0  | 0  | 0  | 0  | 0  | 0  | 1  | 0  | 0  | 0  | 1  |
| 0  | 0  | 0  | 0  | 0  | 1  | 0  | 0  | 0  | 1  | 0  |
| 0  | 0  | 0  | 0  | 1  | 0  | 0  | 0  | 0  | 1  | 1  |
| 0  | 0  | 0  | 1  | 0  | 0  | 0  | 0  | 1  | 0  | 0  |
| 0  | 0  | 1  | 0  | 0  | 0  | 0  | 0  | 1  | 0  | 1  |
| 0  | 1  | 0  | 0  | 0  | 0  | 0  | 0  | 1  | 1  | 0  |
| 1  | 0  | 0  | 0  | 0  | 0  | 0  | 0  | 1  | 1  | 1  |

## Logic

### encoder_4x2
```
Y0 = I1 | I3
Y1 = I2 | I3
```

### encoder_8x3
```
Y0 = I1 | I3 | I5 | I7
Y1 = I2 | I3 | I6 | I7
Y2 = I4 | I5 | I6 | I7
```

## Files

| File | Description |
|------|-------------|
| encoder_4x2.v | 4:2 Encoder RTL |
| encoder_4x2_tb.v | Testbench with all 4 one-hot combinations |
| encoder_8x3.v | 8:3 Encoder RTL |
| encoder_8x3_tb.v | Testbench with all 8 one-hot combinations |

## RTL Code

### encoder_4x2
```verilog
/*RTL Code for 4x2 Encoder
I3 I2 I1 I0 | Y1 Y0
0  0  0  1  | 0  0
0  0  1  0  | 0  1
0  1  0  0  | 1  0
1  0  0  0  | 1  1
*/
module encoder_4x2(
  input  [3:0] i,
  output [1:0] y
);
  assign y[1] = i[2] | i[3]; // Y1 is high when I2 or I3 is high
  assign y[0] = i[1] | i[3]; // Y0 is high when I1 or I3 is high
endmodule
```

### encoder_8x3
```verilog
/*RTL Code for 8x3 Encoder
I7 I6 I5 I4 I3 I2 I1 I0 | Y2 Y1 Y0
0  0  0  0  0  0  0  1  | 0  0  0
0  0  0  0  0  0  1  0  | 0  0  1
0  0  0  0  0  1  0  0  | 0  1  0
0  0  0  0  1  0  0  0  | 0  1  1
0  0  0  1  0  0  0  0  | 1  0  0
0  0  1  0  0  0  0  0  | 1  0  1
0  1  0  0  0  0  0  0  | 1  1  0
1  0  0  0  0  0  0  0  | 1  1  1
*/
module encoder_8x3(
  input  [7:0] in,
  output [2:0] out
);
  assign out[2] = in[7] | in[6] | in[5] | in[4];
  assign out[1] = in[7] | in[6] | in[3] | in[2];
  assign out[0] = in[7] | in[5] | in[3] | in[1];
endmodule
```

## Testbench

### encoder_4x2
```verilog
// Testbench for 4x2 Encoder
`timescale 1ns/1ps
module encoder_4x2_tb();
  reg  [3:0] i;
  wire [1:0] y;
  encoder_4x2 dut(.i(i), .y(y));
  initial begin
    $dumpfile("encoder_4x2_tb.vcd");
    $dumpvars(0, encoder_4x2_tb);
    $display("Time |   I   |  Y  ");
    $display("-----|-------|-----");
    i=4'b0001; #10;
    i=4'b0010; #10;
    i=4'b0100; #10;
    i=4'b1000; #10;
    $finish;
  end
  initial begin
    $monitor("%4t | %4b | %2b", $time, i, y);
  end
endmodule
```

### encoder_8x3
```verilog
// Testbench for 8x3 Encoder
`timescale 1ns/1ps
module encoder_8x3_tb();
  reg  [7:0] in;
  wire [2:0] out;
  encoder_8x3 dut(.in(in), .out(out));
  initial begin
    $dumpfile("encoder_8x3_tb.vcd");
    $dumpvars(0, encoder_8x3_tb);
    $display("Time |    IN    | OUT");
    $display("-----|----------|----");
    in = 8'b00000001; #10;
    in = 8'b00000010; #10;
    in = 8'b00000100; #10;
    in = 8'b00001000; #10;
    in = 8'b00010000; #10;
    in = 8'b00100000; #10;
    in = 8'b01000000; #10;
    in = 8'b10000000; #10;
    $finish;
  end
  initial begin
    $monitor("%4t | %8b | %3b", $time, in, out);
  end
endmodule
```

## Simulation

### encoder_4x2
<img width="705" height="256" alt="image" src="https://github.com/user-attachments/assets/ae69da56-9f3c-44d4-ac94-84d423aca1f0" />
<img width="1850" height="414" alt="image" src="https://github.com/user-attachments/assets/7c3a854b-f7fa-40fb-bbb4-a82f22ddce20" />

### encoder_8x3
<img width="754" height="395" alt="image" src="https://github.com/user-attachments/assets/ce6bd639-92bb-4844-babc-afe3a27e864b" />
<img width="1844" height="564" alt="image" src="https://github.com/user-attachments/assets/541477ce-50bf-475b-9c76-7edfd698a6de" />


Simulated using EDA Playground. One-hot inputs verified against expected binary outputs.
