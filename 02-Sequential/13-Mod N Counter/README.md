# Mod-N Counter

A Mod-N counter counts from 0 to M-1 and resets back to 0 automatically.
The modulus M defines the count range. It is widely used in frequency
division, BCD counters, and clock generation circuits.

## Module

### modn_counter - Parameterized Mod-N Counter
Two parameters - N for bit width, M for modulus.
Default: N=4, M=10 (BCD counter).

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| reset | input | 1-bit | Active high synchronous reset |
| enable | input | 1-bit | 1 = count, 0 = hold |
| q | output | N-bit | Counter output |

## How It Works
```
On every posedge clk:
if reset      → q = 0
if enable
if q == M-1 → q = 0 (wrap)
else        → q = q + 1
else          → q holds
```
## Files

| File | Description |
|------|-------------|
| modn_counter.v | Parameterized Mod-N counter |
| modn_counter_tb.v | Testbench with M+2 cycles to verify wrap |

## RTL Code

```verilog
//RTL Code for Mod-N Counter
module modn_counter #(
  parameter N=4,
  parameter M=10)(
  input clk, reset, enable,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else if(enable) begin
      if(q==(M-1))
        q<=0;
      else
        q<=q+1;
    end
    else
      q<=q;
  end
endmodule
```

## Testbench

```verilog
//Testbench for Mod-N Counter
`timescale 1ns/1ps
module modn_counter_tb();
  //1. Signal Declaration
  localparam N = 4;
  localparam M = 10;    //MOD-N, N-value
  reg clk,reset,enable;
  wire [(N-1):0] q;
  //2. DUT instantiation
  modn_counter #(.N(N),.M(M)) dut(.clk(clk),.reset(reset),.enable(enable),.q(q));
  //3. Clock Generation
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("modn_counter_tb.vcd");
    $dumpvars(0,modn_counter_tb);
    //4.2 Display
    $display("Output for the values of M=%d and N=%d",M,N);
    $display(" Time | Rst En | Q ");
    $display("------|--------|---");
    //4.3 Stimulus
    reset=1; enable=0; #13; //Initial values
    enable=1; #10;          //enable high
    reset=0; #10;           //Reset low
    repeat(M+2)             //M+2 to check resetting value
      @(posedge clk);
    reset=1; #10;
    reset=0; #10;
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,reset,enable,q);
  end
endmodule
```

## Simulation

<img width="400" height="550" alt="image" src="https://github.com/user-attachments/assets/cb6522eb-2c84-421a-b5d9-986e385a448b" />

<img width="1919" height="449" alt="image" src="https://github.com/user-attachments/assets/fd9f0d38-fb17-455f-bafa-b032dc57baec" />

Simulated using EDA Playground. Default M=10 (BCD counter) verified.
Counter resets to 0 after reaching M-1. Wrap behavior confirmed with M+2 cycles.
