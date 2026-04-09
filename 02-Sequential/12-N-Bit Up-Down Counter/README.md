# Up-Down Counter

An Up-Down Counter can count in both directions - up or down - based on
a direction control signal. It increments from 0 to 2ᴺ-1 when counting
up and decrements from 2ᴺ-1 to 0 when counting down, wrapping around
automatically in both directions.

## Module

### updowncounter_nbit - N-bit Up-Down Counter
Parameterized N-bit up-down counter with direction, enable and synchronous reset.
Default width is 4.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| reset | input | 1-bit | Active high synchronous reset |
| enable | input | 1-bit | 1 = count, 0 = hold |
| dir | input | 1-bit | 0 = count up, 1 = count down |
| q | output | N-bit | Counter output |

## How It Works
```
On every posedge clk:
if reset      → q = 0
if enable
if dir=0    → q = q + 1 (up)
if dir=1    → q = q - 1 (down)
else          → q holds
```
## Files

| File | Description |
|------|-------------|
| updowncounter_nbit.v | Parameterized N-bit up-down counter |
| updowncounter_nbit_tb.v | Testbench verifying both count directions |

## RTL Code

```verilog
//RTL Code for N-Bit UP-DOWN Counter
//Dir 1 = DOWN Count, Dir 0 = UP Count
module updowncounter_nbit #(parameter N=4)(
  input clk, reset, enable, dir,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else if(enable) begin
      if(dir)
        q <= q-1;
      else
        q <= q+1;
    end
    else
      q<=q; //q holds if enable and reset is low
  end
endmodule
```

## Testbench

```verilog
//Testbench for N-Bit UP-DOWN Counter
`timescale 1ns/1ps
module updowncounter_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk,reset,enable,dir;
  wire [(N-1):0] q;
  //2. DUT instantiation
  updowncounter_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.enable(enable),.dir(dir),.q(q));
  //3. Clock Generation
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  //4. Waveform and Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("updowncounter_nbit_tb.vcd");
    $dumpvars(0,updowncounter_nbit_tb);
    //4.2 Display
    $display(" Time | Dir Q En Rst");
    $display("------|-----------------");
    //4.3 Stimulus
    dir=0;reset=1;enable=0; #10; //Up Counter, Initial values
    reset=0; #10;                //Reset Low
    enable=1; #10;               //Enable High
    repeat(N)
      @(posedge clk);
    dir=1; #30;                  //Down Counter
    reset=1; #10;                //Reset High
    reset=0; #10;                //Reset low
    repeat(N)
      @(posedge clk);
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b %b",$time,dir,q,enable,reset);
  end
endmodule
```

## Simulation

<img width="400" height="550" alt="image" src="https://github.com/user-attachments/assets/1f62bb4c-34f0-495a-aece-bc7be6a7d91a" />

<img width="1918" height="530" alt="image" src="https://github.com/user-attachments/assets/7c0577d8-31a6-4471-90fb-b7f04178eb0f" />

Simulated using EDA Playground. Up counting and down counting
verified. Direction switch mid-count confirmed. Reset behavior verified.
