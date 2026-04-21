# Johnson Counter - N-Bit

A parameterized N-bit Johnson counter in Verilog. An inverted feedback shift
register that produces 2N unique states - double the states of a ring counter
of the same width. The single change from a ring counter is negating the
feedback bit before wrapping it into the MSB.

## Modules

### johnsoncounter_nbit
Single module. One always block handles reset and shift-with-inversion.

## Ports

| Port    | Direction | Width | Description                         |
|---------|-----------|-------|-------------------------------------|
| `clk`   | input     | 1-bit | System clock                        |
| `reset` | input     | 1-bit | Synchronous reset - clears to zero  |
| `q`     | output    | N-bit | Counter output                      |

## How It Works

On reset, loads all zeros. Each clock cycle shifts right by one, with the
**inverted** LSB wrapping into the MSB position.

For N=4 (8 unique states):
```
Reset  →  0000
Cycle 1→  1000
Cycle 2→  1100
Cycle 3→  1110
Cycle 4→  1111
Cycle 5→  0111
Cycle 6→  0011
Cycle 7→  0001
Cycle 8→  0000  (repeats)
```
Key line:
```verilog
q <= {~q[0], q[(N-1):1]};  // shift right, inverted LSB wraps to MSB
```

## Ring vs Johnson

| | Ring Counter | Johnson Counter |
|---|---|---|
| Feedback | `q[0]` | `~q[0]` |
| Reset state | `000...1` | `000...0` |
| Unique states | N | 2N |
| Pattern | One-hot | Gray-code like |

## Files

| File                        | Description                               |
|-----------------------------|-------------------------------------------|
| `johnsoncounter_nbit.v`     | RTL - parameterized Johnson counter       |
| `johnsoncounter_nbit_tb.v`  | Testbench - full 2N cycle verification    |

## RTL Code

```verilog
//RTL Code for N-Bit Johnson Counter
module johnsoncounter_nbit #(parameter N=4)(
  input clk,reset,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q <= 0;
    else
      q <= {~q[0],q[(N-1):1]};
  end
endmodule
```

## Testbench

```verilog
//Testbench for N-Bit Johnson Counter
`timescale 1ns/1ns
module johnsoncounter_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk,reset;
  wire [(N-1):0] q;
  //2. DUT instantiation
  johnsoncounter_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  //4. Waveform and Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("johnsoncounter_nbit_tb.vcd");
    $dumpvars(0,johnsoncounter_nbit_tb);
    //4.2 Display
    $display(" Time | Rst |  Q ");
    $display("------|-----|-----");
    //4.3 Stimulus
    reset=1; #12;//initial values
    reset=0;
    repeat(N-2)  //for checking reset behaviour
      @(posedge clk);
    reset=1; #20;
    reset=0;
    repeat(2*N)  //full 2N cycle verification
      @(posedge clk);
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b | %b ",$time,reset,q);
  end
endmodule
```

## Simulation

<img width="400" height="500" alt="image" src="https://github.com/user-attachments/assets/bd6f9932-1a62-4583-850e-877a3aba495f" />

<img width="1919" height="315" alt="image" src="https://github.com/user-attachments/assets/d43a799b-734d-4524-8fc4-c21c0b36df26" />

Simulated using EDA Playground. Full 2N=8 state sequence verified for N=4.
Mid-sequence reset confirmed - `#12` delay tests reset between clock edges,
captured cleanly on next posedge. All 8 unique states observed before wrap-around.

## Key Concepts Demonstrated

- Inverted feedback - `~q[0]` wraps to MSB, doubling state count vs ring counter
- 2N unique states - N=4 produces 8 states before repetition
- Synchronous reset - clears to all-zeros, no seed required
- Gray-code like transitions - only one bit changes per cycle

## Tools

- **Simulator:** EDA Playground (Icarus Verilog)
- **Waveform Viewer:** EPWave
- **Language:** Verilog (IEEE 1364-2001)
