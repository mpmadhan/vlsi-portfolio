# Multiplexer (MUX)

A Multiplexer is a data selector — it picks one of many inputs and forwards it
to a single output based on a select signal. Think of it as a controlled switch
that routes data from one of N sources to a single destination.

## Modules

### mux_2x1 — 2:1 Multiplexer
Selects between two inputs using a single select line.
Implemented using gate-level logic.

### mux_4x1 — 4:1 Multiplexer
Selects between four inputs using two select lines.
Implemented using a case statement inside an always block.

## Ports

### mux_2x1
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| a | input | 1-bit | First input |
| b | input | 1-bit | Second input |
| sel | input | 1-bit | Select line |
| y | output | 1-bit | Selected output |

### mux_4x1
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| i0, i1, i2, i3 | input | 1-bit | Four input lines |
| sel | input | 2-bit | Select lines |
| y | output | 1-bit | Selected output |

## Truth Table

### mux_2x1
| Sel | Output |
|-----|--------|
| 0 | A |
| 1 | B |

### mux_4x1
| S1 | S0 | Output |
|----|----|--------|
| 0  | 0  | I0 |
| 0  | 1  | I1 |
| 1  | 0  | I2 |
| 1  | 1  | I3 |

## Logic

### mux_2x1
```
Y = (~Sel & A) | (Sel & B)
// or equivalently
Y = Sel ? B : A
```

### mux_4x1
```
case(sel)
  00 → Y = I0
  01 → Y = I1
  10 → Y = I2
  11 → Y = I3
```

## Files

| File | Description |
|------|-------------|
| mux_2x1.v | 2x1 MUX using gate-level logic |
| mux_2x1_tb.v | Testbench with all input combinations |
| mux_4x1.v | 4x1 MUX using case statement |
| mux_4x1_tb.v | Testbench with distinct input values across all select lines |

## RTL Code

### mux_2x1
```verilog
// RTL Code for 2x1 Multiplexer
module mux_2x1(
  input  a,
  input  b,
  input  sel,
  output y
);
  assign y = (~sel & a) | (sel & b); // gate-level logic
  //assign y = sel ? b : a;          // ternary operator
endmodule
```

### mux_4x1
```verilog
// RTL Code for 4x1 Multiplexer
module mux_4x1(
  input      i0, i1, i2, i3,
  input [1:0] sel,
  output reg y
);
  always @(*) begin
    case (sel)
      2'b00: y = i0;
      2'b01: y = i1;
      2'b10: y = i2;
      2'b11: y = i3;
      default: y = 1'bx;
    endcase
  end
endmodule
```

## Testbench

### mux_2x1
```verilog
// Testbench for 2x1 Multiplexer
`timescale 1ns/1ps
module mux_2x1_tb();
  reg a, b, sel;
  wire y;
  mux_2x1 dut(.a(a), .b(b), .sel(sel), .y(y));
  initial begin
    $dumpfile("mux_2x1_tb.vcd");
    $dumpvars(0, mux_2x1_tb);
    $display(" Time | A B Sel | Output ");
    $display("------|---------|--------");
    a=0; b=0; sel=0; #10;
    a=0; b=0; sel=1; #10;
    a=0; b=1; sel=0; #10;
    a=0; b=1; sel=1; #10;
    a=1; b=0; sel=0; #10;
    a=1; b=0; sel=1; #10;
    a=1; b=1; sel=0; #10;
    a=1; b=1; sel=1; #10;
    #10; $finish;
  end
  initial begin
    $monitor(" %4t | %b %b  %b  |   %b  ", $time, a, b, sel, y);
  end
endmodule
```

### mux_4x1
```verilog
// Testbench for 4x1 Multiplexer
`timescale 1ns/1ps
module mux_4x1_tb();
  reg i0, i1, i2, i3;
  reg [1:0] sel;
  wire y;
  mux_4x1 dut(.i0(i0), .i1(i1), .i2(i2), .i3(i3), .sel(sel), .y(y));
  initial begin
    $dumpfile("mux_4x1_tb.vcd");
    $dumpvars(0, mux_4x1_tb);
    $display("Time | I0 I1 I2 I3 | S0 S1 | Output");
    $display("-----|-------------|-------|-------");
    i0=0; i1=1; i2=0; i3=1;
    sel=2'b00; #10;
    sel=2'b01; #10;
    sel=2'b10; #10;
    sel=2'b11; #10;
    i0=1; i1=0; i2=1; i3=0;
    sel=2'b00; #10;
    sel=2'b01; #10;
    sel=2'b10; #10;
    sel=2'b11; #10;
    $finish;
  end
  initial begin
    $monitor("%4t | %b  %b  %b  %b |  %2b  | %b", $time, i0, i1, i2, i3, sel, y);
  end
endmodule
```

## Simulation

### mux_2x1
<img width="792" height="416" alt="image" src="https://github.com/user-attachments/assets/0026412f-d364-469c-b738-61a3e8e4ab91" />
<img width="1845" height="405" alt="image" src="https://github.com/user-attachments/assets/09480eca-e1e7-4b6a-a777-f8d75dc20330" />

### mux_4x1
<!-- paste simulation screenshot here -->

Simulated using EDA Playground. Select line routing verified for all combinations.
