# VLSI Portfolio - Madhan M.P

RTL Design and Verification portfolio built from the ground up, covering combinational logic, sequential circuits, FSMs, counters, and integrated project-level modules. Each module is independently designed, simulated on EDA Playground (Icarus Verilog + EPWave), and documented with a professional README containing port descriptions, design notes, RTL code, testbench, and waveform screenshots.

**Tools:** Verilog HDL, EDA Playground, Icarus Verilog, EPWave  
**Author:** Madhan M.P - [github.com/mpmadhan](https://github.com/mpmadhan) | [linkedin.com/in/madhan-mp](https://linkedin.com/in/madhan-mp)

---

## Repository Structure

```
vlsi-portfolio/
├── 01-Combinational/
├── 02-Sequential/
└── 03-Projects/
```

---

## 01 - Combinational Logic

Fundamental combinational building blocks implemented in behavioral, dataflow, and structural modeling styles with named port mapping and parameterized designs.

| # | Module | Description |
|---|--------|-------------|
| 01 | Half Adder | 1-bit addition, sum and carry output |
| 02 | Full Adder | 1-bit addition with carry-in, dataflow + structural |
| 03 | Ripple Carry Adder | N-bit parameterized RCA using full adder instances |
| 04 | MUX | 2x1 and 4x1 multiplexer |
| 05 | DEMUX | 1x2 and 1x4 demultiplexer |
| 06 | Encoder | 4x2 and 8x3 priority encoder |
| 07 | Priority Encoder | 4x2 with valid output flag |
| 08 | Decoder | 2x4 and 3x8 with enable |
| 09 | Comparator | 1-bit, 4-bit, and N-bit magnitude comparator |
| 10 | Parity Generator & Checker | N-bit even/odd parity using XOR reduction |

---

## 02 - Sequential Logic

Clocked sequential modules with synchronous and asynchronous reset variants, parameterized for flexible bit-width configuration.

| # | Module | Description |
|---|--------|-------------|
| 01 | D Flip Flop | Sync + async reset variants |
| 02 | JK Flip Flop | All input combinations with reset |
| 03 | T Flip Flop | Toggle flip flop with reset |
| 04 | SR Flip Flop | Set-Reset with invalid state handling |
| 05 | PIPO Shift Register | N-bit parallel-in parallel-out |
| 06 | SIPO Shift Register | N-bit serial-in parallel-out |
| 07 | SISO Shift Register | N-bit serial-in serial-out |
| 08 | PISO Shift Register | N-bit parallel-in serial-out |
| 09 | Universal Shift Register | N-bit with left/right shift, load, hold modes |
| 10 | N-bit Up Counter | Synchronous parameterized up counter |
| 11 | N-bit Down Counter | Synchronous parameterized down counter |
| 12 | N-bit Up-Down Counter | Direction-controlled counter |
| 13 | Mod-N Counter | Configurable modulus counter |
| 14 | Asynchronous Ripple Counter | Async ripple counter with reset |
| 15 | Traffic Light Controller | Moore FSM - 3-state traffic light sequencer |
| 16 | Sequence Detector | Mealy FSM - overlapping 1011 detector |
| 17 | Ring Counter | N-bit self-circulating shift register |
| 18 | Johnson Counter | N-bit twisted ring counter |

---

## 03 - Projects

Integrated RTL modules combining multiple design concepts into complete, functional systems.

| # | Project | Description |
|---|---------|-------------|
| 01 | Traffic Controller System | FSM-based multi-signal traffic controller with pedestrian crossing logic |
| 02 | N-bit ALU | 16-operation parameterized ALU - arithmetic, bitwise, shift, rotate, compare, increment/decrement - with carry and zero flags, macro-controlled testbench |
| 03 | UART | Parameterized UART Transmitter and Receiver - FSM-based 8N1 framing, baud rate generator with 16x oversampling, self-checking testbench |

---

## Design Practices

- Non-blocking assignments (`<=`) for all sequential logic
- Default assignments in combinational blocks to prevent latches
- Parameterized modules using `#(parameter N)` for reusable design
- Named port mapping for all module instantiations
- Synchronous and asynchronous reset strategies
- Self-checking testbenches with `$monitor` and pass/fail reporting
- Waveform validation on EPWave for every module

---

## About

This portfolio was built as part of a structured transition into VLSI RTL Design and Verification, alongside a 6-month industry training program at Silicon Sandbox. Every module was independently designed and coded - no auto-generated RTL.
