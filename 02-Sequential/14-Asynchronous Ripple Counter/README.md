# Asynchronous Ripple Counter

An Asynchronous Ripple Counter is built by chaining T Flip Flops where each
flip flop is clocked by the output of the previous stage. Unlike synchronous
counters where all flip flops share the same clock, here the clock ripples
through each stage - hence the name ripple counter. This causes a small
propagation delay between stages which can lead to glitches at higher frequencies.

## Modules

### tff_async
Asynchronous T Flip Flop - submodule used internally by the ripple counter.
Defined in the same file.

### async_ripplecounter_4bit
4-bit ripple counter built by chaining 4 tff_async instances.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | System clock |
| reset | input | 1-bit | Active high asynchronous reset |
| q | output | N-bit | Counter output |

## How It Works
```
FF0: clocked by system clk   → q[0] toggles every clk edge
FF1: clocked by q[0]         → q[1] toggles every 2 clk edges
FF2: clocked by q[1]         → q[2] toggles every 4 clk edges
FF3: clocked by q[2]         → q[3] toggles every 8 clk edges
Result: q counts 0000 → 0001 → 0010 → ... → 1111 → 0000
```
## Synchronous vs Asynchronous

| | Synchronous | Asynchronous |
|---|---|---|
| Clock | Same for all FFs | Chained through FF outputs |
| Speed | Fast | Slow - ripple delay |
| Glitches | No | Yes |
| Implementation | Behavioral | Structural TFF chaining |

## Files

| File | Description |
|------|-------------|
| async_ripplecounter_4bit.v | RTL with tff_async submodule |
| async_ripplecounter_4bit_tb.v | Testbench covering full count cycle |

## RTL Code

```verilog
/*RTL Code for Asynchronous Ripple counter
We require Asynchronous T flip flop to code Asynchronous Ripple counter
Creating Async T Flip flop module first*/
module tff_async(
  input clk,reset,
  output reg q
);
  always @(posedge clk or posedge reset) begin
    if(reset)
      q<=0;
    else
      q<=~q;
  end
endmodule
//4-Bit Asynchronous Ripple Counter
module async_ripplecounter_4bit #(parameter N=4)(
  input clk,reset,
  output [(N-1):0] q
);
  tff_async ff0(.clk(clk),.reset(reset),.q(q[0]));
  tff_async ff1(.clk(q[0]),.reset(reset),.q(q[1]));
  tff_async ff2(.clk(q[1]),.reset(reset),.q(q[2]));
  tff_async ff3(.clk(q[2]),.reset(reset),.q(q[3]));
endmodule
```

## Testbench

```verilog
//Testbench for 4-Bit Asynchronous Ripple Counter
`timescale 1ns/1ns
module async_ripplecounter_4bit_tb();
  //1. Signal declaration
  localparam N=4;
  reg clk,reset;
  wire [(N-1):0] q;
  //2. DUT instantiation
  async_ripplecounter_4bit #(.N(N)) dut(.clk(clk),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  //4. Waveform +Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("async_ripplecounter_4bit_tb.vcd");
    $dumpvars(0,async_ripplecounter_4bit_tb);
    //4.2 Display
    $display("Time | Rst Q");
    $display("-----|------");
    //4.3 Stimulus
    reset=1; @(posedge clk);    //Reset high
    reset=0;                    //Reset low
    repeat(1<<N)                //For 2^N clock cycles
      @(posedge clk);
    #100; @(posedge clk);		    //delay
    reset=1; @(posedge clk);    //Reset high
    reset=0; @(posedge clk);    //Reset low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b",$time,reset,q);
  end
endmodule
```

## Simulation

<img width="400" height="550" alt="image" src="https://github.com/user-attachments/assets/c90c1549-6e68-44a6-a50b-c3f850ec6269" /> <img width="400" height="550" alt="image" src="https://github.com/user-attachments/assets/692c15ba-3145-46cb-a028-1b4c63100b28" />


<img width="1918" height="416" alt="image" src="https://github.com/user-attachments/assets/6391be0d-4abf-49af-9c9d-1a15fd75001f" />

Simulated using EDA Playground. Full 4-bit count cycle verified.
Ripple behavior observable in waveform - note slight delay between stages.
Reset behavior confirmed.
