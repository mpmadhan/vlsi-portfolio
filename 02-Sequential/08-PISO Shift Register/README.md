# PISO - Parallel In Serial Out Shift Register

A PISO register loads all N bits simultaneously when load is high, then shifts
them out one bit at a time on each rising clock edge. It is used in parallel
to serial data conversion - a classic example being a UART transmitter where
parallel data from a processor is sent serially over a communication line.

## Module

### piso_nbit - N-bit PISO
Parameterized N-bit parallel in serial out shift register.
Default width is 4. Data is loaded in parallel and shifted out MSB first.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| reset | input | 1-bit | Active high synchronous reset |
| load | input | 1-bit | 1 = load parallel data, 0 = shift |
| d | input | N-bit | Parallel data input |
| q | output | 1-bit | Serial data output |

## How It Works
```
On every posedge clk:
if reset → shift_reg = 0
if load  → shift_reg = d (parallel load)
else     → shift_reg = {1'b0, shift_reg[N-1:1]} (right shift)
Serial output is MSB of internal shift register:
q = shift_reg[N-1]
After N clock cycles with load=0, full parallel data
appears at q one bit at a time, MSB first.
```
## Files

| File           | Description                                |
|----------------|--------------------------------------------|
| piso_nbit.v    | Parameterized N-bit PISO shift register    |
| piso_nbit_tb.v | Testbench with load and shift verification |

## RTL Code

```verilog
//RTL Code for Parallel IN Serial OUT Shift Register
module piso_nbit #(parameter N=4)(
  input clk, reset, load,
  input [(N-1):0] d,
  output q
);
  reg [(N-1):0] shift_reg;
  always @(posedge clk) begin
    if(reset)
      shift_reg <= 0;
    else if(load)
      shift_reg <= d;
    else
      shift_reg <= {shift_reg[(N-2):0],1'b0};
  end
  assign q = shift_reg[N-1];
endmodule
```

## Testbench

```verilog
//Testbench for Parallel IN Serial OUT Shift Register
`timescale 1ns/1ps
module piso_nbit_tb();
  //1. Signal declaration
  localparam N = 4;
  reg clk, reset, load;
  reg [(N-1):0] d;
  wire q;
  integer i;
  //2. DUT instantiation
  piso_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.load(load),.d(d),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("piso_nbit_tb.vcd");
    $dumpvars(0,piso_nbit_tb);
    //4.2 Display
    $display(" Time |   D   Load Rst | Q ");
    $display("------|----------------|---");
    //4.3 Stimulus
    d='b1011; load=0; reset=1; #13; //Reset High
    load=0; reset=0; #10;           //Reset Low
    load=1; #10;                    //Load High
    load=0;
    repeat(N) begin
      #10;
    end
    d='b0110; load=1; #10;
    load=0;
    repeat(N) begin
      #10;
    end
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b",$time,d,load,reset,q);
  end
endmodule
```

## Simulation

<img width="300" height="450" alt="image" src="https://github.com/user-attachments/assets/41299506-1484-4c1b-ac3c-ee99a30ce5df" />

<img width="1919" height="528" alt="image" src="https://github.com/user-attachments/assets/6a84ad17-1eef-4937-a843-c1c0f09efadc" />

Simulated using EDA Playground. Parallel data loaded and verified
to appear serially at output MSB first over N clock cycles.
