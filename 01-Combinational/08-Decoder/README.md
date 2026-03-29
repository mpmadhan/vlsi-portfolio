# Decoder

A Decoder takes an n-bit binary input and activates exactly one of 2^n output lines
corresponding to that binary value. 

## Modules

### decoder_2x4 - 2:4 Decoder
2-bit binary input, 4 one-hot output lines.

### decoder_3x8 - 3:8 Decoder
3-bit binary input, 8 one-hot output lines.

Both implemented using a case statement inside an always block.

## Ports

### decoder_2x4
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| in | input | 2-bit | Binary input address |
| out | output | 4-bit | One-hot decoded output |

### decoder_3x8
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| in | input | 3-bit | Binary input address |
| out | output | 8-bit | One-hot decoded output |

## Truth Table

### decoder_2x4
| A1 | A0 | Y3 | Y2 | Y1 | Y0 |
|----|----|----|----|----|-----|
| 0  | 0  | 0  | 0  | 0  | 1  |
| 0  | 1  | 0  | 0  | 1  | 0  |
| 1  | 0  | 0  | 1  | 0  | 0  |
| 1  | 1  | 1  | 0  | 0  | 0  |

### decoder_3x8
| A2 | A1 | A0 | Active Output |
|----|----|----|---------------|
| 0  | 0  | 0  | Y0 = 00000001 |
| 0  | 0  | 1  | Y1 = 00000010 |
| 0  | 1  | 0  | Y2 = 00000100 |
| 0  | 1  | 1  | Y3 = 00001000 |
| 1  | 0  | 0  | Y4 = 00010000 |
| 1  | 0  | 1  | Y5 = 00100000 |
| 1  | 1  | 0  | Y6 = 01000000 |
| 1  | 1  | 1  | Y7 = 10000000 |

Exactly one output is HIGH at a time.

## Encoder vs Decoder

| Feature | Encoder | Decoder |
|---|---|---|
| Input | 2ⁿ one-hot lines | n-bit binary |
| Output | n-bit binary | 2ⁿ one-hot lines |
| Direction | Many → Few | Few → Many |
| Example | 4:2, 8:3 | 2:4, 3:8 |

## Files

| File | Description |
|------|-------------|
| decoder_2x4.v | 2:4 Decoder RTL |
| decoder_2x4_tb.v | Testbench covering all 4 combinations |
| decoder_3x8.v | 3:8 Decoder RTL |
| decoder_3x8_tb.v | Testbench covering all 8 combinations |

## RTL Code

### decoder_2x4
```verilog
//RTL code for 2x4 Decoder
module decoder_2x4(
  input [1:0] in,
  output reg [3:0] out
);
  always @(*) begin
    case(in)
      2'b00: out=4'b0001;
      2'b01: out=4'b0010;
      2'b10: out=4'b0100;
      2'b11: out=4'b1000;
      default : out=4'bxxxx;
    endcase
  end
endmodule
```

### decoder_3x8
```verilog
//RTL Code for 3x8 Decoder
module decoder_3x8(
  input [2:0] in,
  output reg [7:0] out
);
  always @(*) begin
    case (in)
      3'd0: out=8'b00000001; //8'd1;
      3'd1: out=8'b00000010; //8'd2;
      3'd2: out=8'b00000100; //8'd4;
      3'd3: out=8'b00001000; //8'd8;
      3'd4: out=8'b00010000; //8'd16;
      3'd5: out=8'b00100000; //8'd32;
      3'd6: out=8'b01000000; //8'd64;
      3'd7: out=8'b10000000; //8'd128;
      default : out=8'bx;
    endcase
  end
endmodule
```

## Testbench

### decoder_2x4
```verilog
//Testbench for 2x4 Decoder
`timescale 1ns/1ps
module decoder_2x4_tb();
  //1. Signal Declaration
  reg [1:0] in;
  wire [3:0] out;
  integer i;
  //2. DUT instantiation
  decoder_2x4 dut(.in(in),.out(out));
  //3. Waveform + Stimukus
  initial begin
    //3.1 Waveform
    $dumpfile ("decoder_2x4_tb.vcd");
    $dumpvars (0,decoder_2x4_tb);
    //3.2 Display
    $display("Time |  In  |  Out  ");
    $display("-----|------|-------");
    //3.3 Stimulus
    for (i=0;i<4;i=i+1) begin
      in = i; #10;
    end
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t |  %2b  |  %4b  ",$time,in,out);
  end
endmodule
```

### decoder_3x8
```verilog
//Testbench 3x8 Decoder
`timescale 1ns/1ps
module decoder_3x8_tb();
  //1. Signal declaration
  reg [2:0] in;
  wire [7:0] out;
  integer i;
  //2. DUT instantiation
  decoder_3x8 dut(.in(in),.out(out));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("decoder_3x8_tb.vcd");
    $dumpvars(0,decoder_3x8_tb);
    //3.2 Display
    $display("Time |   In   |   Out   ");
    $display("-----|--------|---------");
    //3.3 Stimulus
    for(i=0;i<8;i=i+1) begin
      in = i; #10;
    end
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t |   %3b   |   %8b   ",$time,in,out);
  end
endmodule
```

## Simulation

### decoder_2x4

<img width="360" height="159" alt="image" src="https://github.com/user-attachments/assets/b285e5f6-bdd1-4451-a93c-6034c483f53b" />

<img width="1844" height="419" alt="image" src="https://github.com/user-attachments/assets/7dfc4e65-7387-433f-b14d-4a3e6206deed" />

### decoder_3x8

<img width="737" height="391" alt="image" src="https://github.com/user-attachments/assets/e7fd383e-68e2-4470-86ac-613c7b8e07bf" />

<img width="1844" height="578" alt="image" src="https://github.com/user-attachments/assets/2949fa8c-7c1e-4c9e-a516-bc3969a96105" />


Simulated using EDA Playground. All input combinations verified.
Exactly one output line active for each binary input confirmed.
