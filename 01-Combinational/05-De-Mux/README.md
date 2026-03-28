# DeMultiplexer (DEMUX)

A DeMultiplexer is the opposite of a MUX - it takes one input and routes it to
one of many outputs based on a select signal. It is similar to a switch that
directs incoming data to a specific destination.

## Modules

### demux_1x2 - 1:2 DeMultiplexer
Routes one input to one of two outputs using a single select line.
Implemented using gate-level assign statements.

### demux_1x4 - 1:4 DeMultiplexer
Routes one input to one of four outputs using two select lines.
Implemented using a case statement with concatenation for clean output assignment.

## Ports

### demux_1x2
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| in | input | 1-bit | Data input |
| sel | input | 1-bit | Select line |
| y0 | output | 1-bit | Output 0 |
| y1 | output | 1-bit | Output 1 |

### demux_1x4
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| in | input | 1-bit | Data input |
| sel | input | 2-bit | Select lines |
| y0, y1, y2, y3 | output | 1-bit | Output lines |

## Truth Table

### demux_1x2
| Sel | Y0 | Y1 |
|-----|----|----|
| 0   | D  | 0  |
| 1   | 0  | D  |

### demux_1x4
| S1 | S0 | Active Output |
|----|----|---------------|
| 0  | 0  | Y0 = D |
| 0  | 1  | Y1 = D |
| 1  | 0  | Y2 = D |
| 1  | 1  | Y3 = D |

All non-selected outputs are 0.

## Logic

### demux_1x2
```
Y0 = ~Sel & D
Y1 =  Sel & D
```

### demux_1x4
```
case(sel)
  00 → Y0 = D, rest = 0
  01 → Y1 = D, rest = 0
  10 → Y2 = D, rest = 0
  11 → Y3 = D, rest = 0
```

## Files

| File | Description |
|------|-------------|
| demux_1x2.v | 1x2 DEMUX using gate-level logic |
| demux_1x2_tb.v | Testbench for 1x2 DEMUX |
| demux_1x4.v | 1x4 DEMUX using case with concatenation |
| demux_1x4_tb.v | Testbench with in=1 across all select combinations |

## RTL Code

### demux_1x2
```verilog
// RTL Code for 1x2 DEMUX
module demux_1x2(
  input  in,
  input  sel,
  output y0,
  output y1
);
  assign y0 = (~sel & in);
  assign y1 = ( sel & in);
endmodule
```

### demux_1x4
```verilog
// RTL Code for 1x4 DEMUX
module demux_1x4(
  input        in,
  input  [1:0] sel,
  output reg   y0, y1, y2, y3
);
  always @(*) begin
    case (sel)
      2'b00: {y0,y1,y2,y3} = {in,3'b0};
      2'b01: {y0,y1,y2,y3} = {1'b0,in,2'b0};
      2'b10: {y0,y1,y2,y3} = {2'b0,in,1'b0};
      2'b11: {y0,y1,y2,y3} = {3'b0,in};
      default: {y0,y1,y2,y3} = 4'b0;
    endcase
  end
endmodule
```

## Testbench

### demux_1x2
```verilog
// Testbench for 1x2 DEMUX
`timescale 1ns/1ps
module demux_1x2_tb();
  // 1. Signal declaration
  reg  in, sel;
  wire y0, y1;
  // 2. DUT instantiation
  demux_1x2 dut(.in(in), .sel(sel), .y0(y0), .y1(y1));
  // 3. Waveform + Stimulus
  initial begin
    // 3.1 Waveform
    $dumpfile("demux_1x2_tb.vcd");
    $dumpvars(0, demux_1x2_tb);
    // 3.2 Display
    $display("Time | In Sel | Y0 Y1");
    $display("-----|--------|------");
    // 3.3 Stimulus
    in=1; sel=0; #10;  // expect y0=1, y1=0
    in=1; sel=1; #10;  // expect y0=0, y1=1
    $finish;
  end
  // 4. Observation
  initial begin
    $monitor("%4t | %b  %b  | %b  %b", $time, in, sel, y0, y1);
  end
endmodule
```

### demux_1x4
```verilog
// Testbench for 1x4 DEMUX
`timescale 1ns/1ps
module demux_1x4_tb();
  // 1. Signal declaration
  reg        in;
  reg  [1:0] sel;
  wire       y0, y1, y2, y3;
  // 2. DUT instantiation
  demux_1x4 dut(.in(in), .sel(sel), .y0(y0), .y1(y1), .y2(y2), .y3(y3));
  // 3. Waveform + Stimulus
  initial begin
    // 3.1 Waveform
    $dumpfile("demux_1x4_tb.vcd");
    $dumpvars(0, demux_1x4_tb);
    // 3.2 Display
    $display("Time | In Sel | Y0 Y1 Y2 Y3");
    $display("-----|--------|------------");
    // 3.3 Stimulus
    in=1; sel=2'b00; #10;  // expect y0=1
    in=1; sel=2'b01; #10;  // expect y1=1
    in=1; sel=2'b10; #10;  // expect y2=1
    in=1; sel=2'b11; #10;  // expect y3=1
    $finish;
  end
  // 4. Observation
  initial begin
    $monitor("%4t | %b  %2b | %b  %b  %b  %b", $time, in, sel, y0, y1, y2, y3);
  end
endmodule
```

## Simulation

### demux_1x2

<img width="640" height="243" alt="image" src="https://github.com/user-attachments/assets/11faa5f4-1509-4013-b367-a0780d3735e1" />
  
<img width="1850" height="313" alt="image" src="https://github.com/user-attachments/assets/60a5d340-3fdb-4e54-94d4-176aa7cd44fa" />

### demux_1x4

<img width="664" height="273" alt="image" src="https://github.com/user-attachments/assets/b8d64bc5-3bb1-4566-8a9e-9d9cfacde6a6" />

<img width="1850" height="418" alt="image" src="https://github.com/user-attachments/assets/bfc703cd-8d63-4341-a002-65a2d2e6beef" />

Simulated using EDA Playground. Output routing verified for all select combinations with in=1.
