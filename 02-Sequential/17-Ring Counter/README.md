# Ring Counter - N-Bit

A parameterized N-bit ring counter in Verilog. A single `1` circulates through
N flip-flops on every rising clock edge. Built as a shift register with LSB
fed back into MSB - no external logic needed beyond the register itself.

## Modules

### ringcounter_nbit
Single module. One always block handles both reset (seed loading) and shift operation.

## Ports

| Port    | Direction | Width  | Description                        |
|---------|-----------|--------|------------------------------------|
| `clk`   | input     | 1-bit  | System clock                       |
| `reset` | input     | 1-bit  | Synchronous reset - loads seed `1` |
| `q`     | output    | N-bit  | Counter output                     |

## How It Works

On reset, loads `000...1` into the register. Each clock cycle shifts right by one,
with the LSB wrapping back into the MSB position.

For N=4:
```
Reset  →  0001
Cycle 1→  1000
Cycle 2→  0100
Cycle 3→  0010
Cycle 4→  0001  (repeats)
```
Key line:
```verilog
q <= {q[0], q[(N-1):1]};  // shift right, LSB wraps to MSB
```

Only one bit is ever HIGH at any time - guaranteed by design.

## Files

| File                      | Description                              |
|---------------------------|------------------------------------------|
| `ringcounter_nbit.v`      | RTL - parameterized ring counter         |
| `ringcounter_nbit_tb.v`   | Testbench - full cycle and reset verify  |

## RTL Code

```verilog
//RTL Code for N-Bit Ring Counter
module ringcounter_nbit #(parameter N=4)(
  input clk,reset,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q <= {{(N-1){1'b0}},1'b1};
    else
      q <= {q[0],q[(N-1):1]};
  end
endmodule
```

## Testbench

```verilog
//Testbench for N-Bit Ring Counter
`timescale 1ns/1ns
module ringcounter_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk,reset;
  wire [(N-1):0] q;
  //2. DUT instantiation
  ringcounter_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  //4. Waveform and Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("ringcounter_nbit_tb.vcd");
    $dumpvars(0,ringcounter_nbit_tb);
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
    repeat(N+2)  //repeating for N+2 clock cycles
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

<img width="400" height="550" alt="image" src="https://github.com/user-attachments/assets/12b54bc2-9b40-4438-871e-9d9c233bde08" />
  
<img width="1918" height="335" alt="image" src="https://github.com/user-attachments/assets/ac04bdc0-18d4-4335-b7fe-6fb81603f83c" />

Simulated using EDA Playground. Full N-cycle rotation verified - single `1` circulates
without corruption. Mid-sequence reset confirmed - `#12` delay intentionally tests
reset assertion between clock edges, verifying capture on next posedge. Wrap-around
from `0001` back to `1000` verified cleanly.

## Key Concepts Demonstrated

- Feedback shift register - LSB wraps to MSB via concatenation
- Parameterized seed - `{{(N-1){1'b0}}, 1'b1}` scales with N
- One-hot output - exactly one bit HIGH at all times by construction
- Synchronous reset - seed loaded on clock edge, no glitch

## Tools

- **Simulator:** EDA Playground (Icarus Verilog)
- **Waveform Viewer:** EPWave
- **Language:** Verilog (IEEE 1364-2001)
