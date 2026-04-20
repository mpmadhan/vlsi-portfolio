# Sequence Detector - Mealy FSM (1011)

A Mealy Finite State Machine implementing a serial sequence detector for the pattern
**1011** in Verilog. The detector monitors a single-bit input stream and asserts the
output in the same cycle the final bit of the pattern arrives - the defining
characteristic of a Mealy machine. Supports both overlapping and non-overlapping
detection modes via a single line change.

## Modules

### mealy_1011_detector
Single top-level module. Contains two always blocks - a sequential state register
and a combined combinational block handling next-state logic and output together.

## Ports

| Port    | Direction | Width | Description                              |
|---------|-----------|-------|------------------------------------------|
| `clk`   | input     | 1-bit | System clock                             |
| `reset` | input     | 1-bit | Synchronous reset - forces state to S0   |
| `din`   | input     | 1-bit | Serial input bitstream                   |
| `q`     | output    | 1-bit | HIGH for one cycle when 1011 is detected |

## How It Works

Four states track progress through the target pattern `1011`. Each state represents
how many bits of the sequence have been matched so far.

| State | Meaning           |
|-------|-------------------|
| `S0`  | Idle - no match   |
| `S1`  | Matched `1`       |
| `S2`  | Matched `10`      |
| `S3`  | Matched `101`     |

Output `q` is asserted combinationally in S3 when `din=1` completes the pattern -
no clock edge required, output appears the same cycle the final bit arrives.

## State Transition Table

| Current State | Input | Next State (Overlap) | Output |
|---------------|-------|----------------------|--------|
| S0            | 0     | S0                   | 0      |
| S0            | 1     | S1                   | 0      |
| S1            | 0     | S2                   | 0      |
| S1            | 1     | S1                   | 0      |
| S2            | 0     | S0                   | 0      |
| S2            | 1     | S3                   | 0      |
| S3            | 0     | S2                   | 0      |
| S3            | 1     | S1 *(or S0)*         | 1 ✅   |

> S3 on input `0` returns to S2 - not S0. The prefix `10` is still valid and
> progress is preserved. S1 on input `1` stays at S1 - a repeated `1` neither
> breaks nor advances the match.

## Overlapping vs Non-Overlapping

Both modes are implemented. One line controls the behavior:

```verilog
// Overlapping - detected sequence can share bits with the next
next_state = S1;

// Non-Overlapping - restart from scratch after detection
// next_state = S0;
```

For input stream `1 0 1 1 0 1 1`:
- Overlapping → detects at position 4, then again at position 7
- Non-Overlapping → detects at position 4 only, restarts fresh

## Moore vs Mealy

|                   | Moore          | Mealy                  |
|-------------------|----------------|------------------------|
| Output depends on | State only     | State + current input  |
| Output change     | Next clock edge| Same cycle input arrives|
| States needed     | More           | Fewer                  |
| Implementation    | Separate output block | Output inside combinational block |

## Files

| File                          | Description                                      |
|-------------------------------|--------------------------------------------------|
| `mealy_1011_detector.v`       | RTL - Mealy FSM, overlapping detection           |
| `mealy_1011_detector_tb.v`    | Testbench - pattern, overlap, and reset tests    |

## RTL Code

```verilog
//RTL Code for Mealy Sequence detector - 1011
module mealy_1011_detector(
  //1. Ports
  input clk,reset,din,
  output reg q
);
  //2. State encoding
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;
  //3. Sequential Block
  reg [1:0] state,next_state;
  always @(posedge clk) begin
    if(reset)
      state <= S0;
    else
      state <= next_state;
  end
  //4. Combinational block
  always @(*) begin
    next_state = state;
    q=0;
    case(state)
      S0: begin
        if(din)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if(din)
          next_state = S1;
        else
          next_state = S2;
      end
      S2: begin
        if(din)
          next_state = S3;
        else
          next_state = S0;
      end
      S3: begin
        if(din) begin
          next_state = S1; //Overlapping
          //next_state = S0; //Non-Overlapping
          q=1;
        end
        else
          next_state = S2;
      end 
    endcase
  end
endmodule
```

## Testbench

```verilog
//Testbench for Mealy Sequence Detector - 1011
`timescale 1ns/1ns
module mealy_1011_detector_tb();
  //1. Signal Declaration
  reg clk,reset,din;
  wire q;
  //2. DUT instantiation
  mealy_1011_detector dut(.clk(clk),.reset(reset),.din(din),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("mealy_1011_detector_tb.vcd");
    $dumpvars(0,mealy_1011_detector_tb);
    //4.2 Display
    $display(" Time | Rst Din | Q");
    $display("------|---------|---");
  end
  //4.3 Stimulus
  initial begin
    reset=1; din=0; //initial values
    #10;
    reset=0; #10; //Reset low
    //1011 Testing
    @(posedge clk) din=1;
    @(posedge clk) din=0; 
    @(posedge clk) din=1;
    @(posedge clk) din=1;
    //Overlapping teset
    @(posedge clk) din=0;
    @(posedge clk) din=1;
    @(posedge clk) din=1;
    //Mid-reset test
    @(posedge clk) din=1;
    @(posedge clk) reset=1;
    @(posedge clk) reset=0;
    //1011 testing for 3 cycles
    repeat(3) begin
      @(posedge clk) din=1;
      @(posedge clk) din=0; 
      @(posedge clk) din=1;
      @(posedge clk) din=1;
    end
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,reset,din,q);
  end
endmodule
```

## Simulation

<img width="500" height="550" alt="image" src="https://github.com/user-attachments/assets/567fc9c9-1561-4b57-9a2c-6e92425dc957" />

<img width="1911" height="341" alt="image" src="https://github.com/user-attachments/assets/bf43d04e-006b-40e1-989f-9ba4c5e2273c" />

Simulated using EDA Playground. Clean `1011` detection verified - `q` asserts
combinationally on the final bit. Overlapping behavior confirmed - back-to-back
`1011` patterns share the trailing `1`. Mid-sequence reset verified - FSM returns
to S0 and resumes correctly. Three consecutive pattern repetitions pass cleanly.

## Key Concepts Demonstrated

- Mealy FSM structure - output evaluated combinationally alongside next-state logic
- Default output assignment - `q=0` at top of combinational block prevents latches
- Overlapping detection - S3 returns to S1 on match, preserving the leading `1`
- Partial match preservation - S3 on `din=0` returns to S2, not S0
- Synchronous reset - state snaps to S0 on next rising edge, no glitch

## Tools

- **Simulator:** EDA Playground (Icarus Verilog)
- **Waveform Viewer:** EPWave
- **Language:** Verilog (IEEE 1364-2001)
