# Priority Encoder

A Priority Encoder solves the limitation of a basic encoder - when multiple inputs
are active simultaneously, it outputs the binary code of the highest priority input
(highest index wins). A valid output flag indicates whether any input is active at all.

## Module

### priority_encoder_4x2 - 4:2 Priority Encoder
4 inputs with priority, 2-bit binary output, 1-bit valid flag.
Implemented using if-else if chain inside an always block.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| in | input | 4-bit | Input lines (in[3] = highest priority) |
| out | output | 2-bit | Binary encoded output |
| valid | output | 1-bit | 1 = valid input active, 0 = no input active |

## Truth Table

| I3 | I2 | I1 | I0 | Y1 | Y0 | Valid |
|----|----|----|----|----|-----|-------|
| 0  | 0  | 0  | 0  | x  | x  | 0 |
| 0  | 0  | 0  | 1  | 0  | 0  | 1 |
| 0  | 0  | 1  | x  | 0  | 1  | 1 |
| 0  | 1  | x  | x  | 1  | 0  | 1 |
| 1  | x  | x  | x  | 1  | 1  | 1 |

x = don't care (input can be 0 or 1, higher priority input takes over)

## Logic
```
if I3 active      → out = 11 (highest priority)
else if I2 active → out = 10
else if I1 active → out = 01
else if I0 active → out = 00 (lowest priority)
else              → out = xx, valid = 0 (no input active)
```

## Key Difference from Basic Encoder

| Feature | Basic Encoder | Priority Encoder |
|---|---|---|
| Multiple inputs active | Wrong output | Highest priority wins |
| No input active | Undefined | valid = 0 |
| Complexity | Simple OR gates | if-else if chain |

## Files

| File | Description |
|------|-------------|
| priority_encoder_4x2.v | RTL design with valid output |
| priority_encoder_4x2_tb.v | Testbench covering all 16 input combinations via for loop |

## RTL Code
```verilog
//RTL Code for 4x2 Priority Encoder
/*
I3 I2 I1 I0 | Y1 Y0
0  0  0  1  | 0  0
0  0  1  X  | 0  1
0  1  X  X  | 1  0
1  X  X  X  | 1  1
*/
module priority_encoder_4x2(
  input [3:0] in,
  output reg [1:0] out,
  output reg valid
);
  always @(*) begin
    if(in[3]) begin
      out=2'b11;
      valid = 1;
    end
    else if(in[2]) begin
      out= 2'b10;
      valid = 1;
    end
    else if(in[1]) begin
      out=2'b01;
      valid =1;
    end
    else if(in[0]) begin
      out=2'b00;
      valid =1;
    end
    else begin
      out=2'bxx;
      valid =0;
    end
  end
endmodule
```

## Testbench
```verilog
//Testbench for 4x2 Priority Encoder
`timescale 1ns/1ps
module priority_encoder_4x2_tb();
  //1. Signal declaration
  reg [3:0] in;
  wire [1:0] out;
  wire valid;
  integer i;
  //2. DUT instantiation
  priority_encoder_4x2 dut(.in(in),.out(out),.valid(valid));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile ("priority_encoder_4x2_tb.vcd");
    $dumpvars (0,priority_encoder_4x2_tb);
    //3.2 Display
    $display ("Time  |   In   |  Out  | Valid");
    $display ("------|--------|-------|------");
    //3.3 Stimulus
    in=4'b0000;
    for (i=0;i<=15;i=i+1) begin
      in = i; #10;
    end
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t  |   %4b   |  %2b | %b",$time,in,out,valid);
  end
endmodule
```

## Simulation

<img width="842" height="598" alt="image" src="https://github.com/user-attachments/assets/7acf0f22-b1b2-4b68-b209-2e5e64a0519d" />
  
<img width="1847" height="444" alt="image" src="https://github.com/user-attachments/assets/c0885c37-2ebf-47d4-91e6-7d7c7eef5624" />

Simulated using EDA Playground. All 16 input combinations tested via for loop.
Priority behavior verified - highest active input index always wins.
