# Universal Shift Register

A Universal Shift Register combines all four shift register operations into
a single module controlled by a 2-bit select signal. It can hold, shift right,
shift left, or load data in parallel - making it the most flexible and complete
shift register design. It is widely used in ALUs, communication interfaces,
and digital signal processing pipelines.

## Module

### universal_nbit - N-bit Universal Shift Register
Parameterized N-bit universal shift register with four modes.
Default width is 4.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| reset | input | 1-bit | Active high synchronous reset |
| enable | input | 1-bit | Enable signal - operations only when high |
| sel | input | 2-bit | Mode select |
| left_in | input | 1-bit | Bit shifted in during left shift |
| right_in | input | 1-bit | Bit shifted in during right shift |
| d | input | N-bit | Parallel data input |
| q | output | N-bit | Parallel data output |

## Mode Select

| sel | Operation | Description |
|-----|-----------|-------------|
| 00 | Hold | Output retains current value |
| 01 | Shift Right | MSB filled with right_in, LSB dropped |
| 10 | Shift Left | LSB filled with left_in, MSB dropped |
| 11 | Parallel Load | All bits loaded from d simultaneously |

## How It Works
```
On every posedge clk:
if reset  → shift_reg = 0
if enable →
sel=00: shift_reg = shift_reg
sel=01: shift_reg = {right_in, shift_reg[N-1:1]}
sel=10: shift_reg = {shift_reg[N-2:0], left_in}
sel=11: shift_reg = d
```
## Files

| File | Description |
|------|-------------|
| universal_nbit.v | Parameterized N-bit universal shift register |
| universal_nbit_tb.v | Testbench covering all 4 modes |

## RTL Code

```verilog
//RTL Code for N-Bit Universal Shift Register
//Universal shift register, 4 operations: 1.Hold, 2.Shift Right, 3.Shift Left, 4.Parallel load
module universal_nbit #(parameter N=4)(
  input clk, reset, load,
  input [1:0] sel,
  input enable, left_in, right_in,
  input [(N-1):0] d,
  output [(N-1):0] q
);
  reg [(N-1):0] shift_reg;
  always @(posedge clk) begin
    if(reset)
      shift_reg <= 0;
    else if(enable) begin
      case(sel)
        2'b00: shift_reg <= shift_reg;
        2'b01: shift_reg <= {right_in,shift_reg[(N-1):1]};
        2'b10: shift_reg <= {shift_reg[(N-2):0],left_in};
        2'b11: shift_reg <= d;
        default: shift_reg <= shift_reg;
      endcase
    end
  end
  assign q = shift_reg;
endmodule
```

## Testbench

```verilog
//Testbench for N-Bit Universal Shift Register
//Sel: 0: Hold, 1: Shift Right, 2: Shift Left, 3: Load
`timescale 1ns/1ps
module universal_nbit_tb();
  //1. Signal declaration
  localparam N = 4;
  reg clk, reset;
  reg [1:0] sel;
  reg [(N-1):0] d;
  reg enable, left_in, right_in;
  wire [(N-1):0] q;
  //2. DUT instantiation
  universal_nbit #(.N(N)) dut(.clk(clk),
                              .reset(reset),
                              .sel(sel),
                              .d(d),
                              .enable(enable),
                              .left_in(left_in),
                              .right_in(right_in),
                              .q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("universal_nbit_tb.vcd");
    $dumpvars(0,universal_nbit_tb);
    //4.2 Display
    $display(" Time | Rst Sel   D    En Left Right | Q ");
    $display("------|------------------------------|---");
    //4.3 Stimulus
    sel=2'b00;d='b1011;enable=0;left_in=0;right_in=0;reset=1; #10;
    reset=0; enable=1;
    sel=2'b11; #13;               //Loading input into Shift_reg
    sel=2'b01;                    //Right Shift
    repeat(N) begin
      #10;
    end
    sel=2'b10;                    //Left Shift
    repeat(N) begin
      #10;
    end
    d='b0110;sel=2'b11;left_in=1;right_in=1; #10;
    sel=2'b01;                    //Right Shift
    repeat(N) begin
      #10;
    end
    sel=2'b10;                    //Left Shift
    repeat(N) begin
      #10;
    end
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b %b %b %b %b | %b",
              $time,reset,sel,d,enable,left_in,right_in,q);
  end
endmodule
```

## Simulation

<img width="300" height="450" alt="image" src="https://github.com/user-attachments/assets/e0d58fbf-98db-4fbc-806b-10ce8276c8c9" />

<img width="1919" height="639" alt="image" src="https://github.com/user-attachments/assets/d214611f-7028-4d77-96b6-b41facc71820" />

Simulated using EDA Playground. All four modes verified -
Hold, Shift Right, Shift Left and Parallel Load.
