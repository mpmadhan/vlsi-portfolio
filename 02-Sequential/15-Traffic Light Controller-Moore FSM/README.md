# Traffic Light Controller - Moore FSM

A Moore Finite State Machine implementing a three-phase traffic light controller in Verilog.
The controller sequences through RED, GREEN, and YELLOW states with fixed dwell times
enforced by an internal cycle counter. Outputs are strictly a function of current state -
the defining characteristic of a Moore machine.

## Modules

### traffic_signal_fsm
Single top-level module. Contains four always blocks with clearly separated responsibilities:
state register, cycle counter, next-state logic, and output logic.

## Ports

| Port     | Direction | Width | Description                             |
|----------|-----------|-------|-----------------------------------------|
| clk      | input     | 1-bit | System clock                            |
| reset    | input     | 1-bit | Synchronous reset - forces state to RED |
| red      | output    | 1-bit | HIGH when current state is RED          |
| green    | output    | 1-bit | HIGH when current state is GREEN        |
| yellow   | output    | 1-bit | HIGH when current state is YELLOW       |

## How It Works

The FSM cycles through three states using an internal 3-bit counter to track dwell time.

FF0 → State register: advances state ← next_state on every rising edge  
Counter → Increments each cycle; resets when a transition is taken  
Next-state logic → Checks count threshold and asserts counter_reset on transition  
Output logic → Drives red/green/yellow as Boolean comparisons against current state  

Sequence: RED (5 cycles) → GREEN (5 cycles) → YELLOW (2 cycles) → RED ...

Count threshold of 4 produces 5-cycle dwell (0→1→2→3→4).  
Count threshold of 1 produces 2-cycle dwell (0→1).

## State Encoding

| State    | Encoding | Duration |
|----------|----------|----------|
| `RED`    | `2'b00`  | 5 cycles |
| `GREEN`  | `2'b01`  | 5 cycles |
| `YELLOW` | `2'b10`  | 2 cycles |

## Moore vs Mealy

| | Moore | Mealy |
|---|---|---|
| Output depends on | State only | State + Inputs |
| Output change | On clock edge | Immediately with input |
| Glitches | No | Possible |
| States needed | More | Fewer |

## Files

| File                       | Description                              |
|----------------------------|------------------------------------------|
| traffic_signal_fsm.v       | RTL - Moore FSM with internal counter    |
| traffic_signal_fsm_tb.v    | Testbench covering reset and full cycle  |

## RTL Code

```verilog
//RTL Code ofr Traffic Light Controller Moore FSM
//RED (5 Cycles) -> GREEN (5 Cycles) -> YELLOW (2 Cycles) -> RED (5 Cycles)
module traffic_signal_fsm(
  //1. Ports
  input clk,reset,
  output reg red,green,yellow
);
  //2. State Encoding
  parameter RED = 2'b00;
  parameter GREEN = 2'b01;
  parameter YELLOW = 2'b10;
  //3. Sequential block
  reg [1:0] state,next_state;
  always @(posedge clk) begin
    if(reset)
      state <= RED;
    else
      state <= next_state;
  end
  //4. Count block
  reg [2:0] count;
  reg counter_reset;
  always @(posedge clk) begin
    if(reset || counter_reset)
      count<=0;
    else
      count<=count+1;
  end
  //5. Combinational block
  always @(*) begin
    next_state = state;
    counter_reset = 0;
    case(state)
      RED: begin
        if(count == 4) begin
          next_state = GREEN;
          counter_reset = 1;
        end
      end
      GREEN: begin
        if(count == 4) begin
          next_state = YELLOW;
          counter_reset = 1;
        end
      end
      YELLOW: begin
        if(count == 1) begin
          next_state = RED;
          counter_reset = 1;
        end
      end
      default: next_state = RED;
    endcase
  end
  //6. Output
  always @(*) begin
    red = (state == RED);
    green = (state == GREEN);
    yellow = (state == YELLOW);
  end
endmodule
```

## Testbench

```verilog
//Testbench for Traffic Light Controller Moore FSM
// RED (5 cycles) -> GREEN (5 cycles) -> YELLOW (2 cycles) 
`timescale 1ns/1ns
module traffic_signal_fsm_tb();
  //1. Signal Declaration
  reg clk,reset;
  wire red,green,yellow;
  //2. DUT instantiation
  traffic_signal_fsm dut(.clk(clk),.reset(reset),.red(red),.green(green),.yellow(yellow));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform +Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("traffic_signal_fsm_tb.vcd");
    $dumpvars(0,traffic_signal_fsm_tb);
    //4.2 Display
    $display(" Time | Rst | R G Y ");
    $display("------|-----|-------");
    //4.3 Stimulus
    reset=1; #10;
    reset=0; #10;
    repeat(5)
      @(posedge clk); //for 8 cycles
    reset=1; #10;
    reset=0; #10;
    repeat(15)
      @(posedge clk); //for 15 cycles
    $finish;
  end
  //5. Observation
  always @(posedge clk) begin            //Always block as we need to see the clock cycles and not monitor the values.
    $display("%4t | %b | %b %b %b ",$time,reset,red,green,yellow);
  end
endmodule
```

## Simulation

<img width="400" height="550" alt="image" src="https://github.com/user-attachments/assets/f552dd43-b458-4eb3-ac56-b51abecce291" />

<img width="1917" height="342" alt="image" src="https://github.com/user-attachments/assets/55090be3-9ecf-4e91-8f18-e0f31e503a58" />

Simulated using EDA Playground. Full RED → GREEN → YELLOW → RED cycle verified.  
Mid-sequence reset confirmed - FSM snaps back to RED immediately.  
Moore output behavior verified - outputs change only on state transitions, never mid-state.

## Key Concepts Demonstrated

- Moore FSM - outputs are functions of state only, inputs never appear in output logic
- Four separated always blocks - state register, counter, next-state logic, output logic
- Internal cycle counter - self-contained timing, no external timer needed
- Synchronous reset - state and counter reset on the same clock edge, no skew
- `counter_reset` handshake - counter clears on the same cycle a transition is taken

## Tools

- **Simulator:** EDA Playground (Icarus Verilog)
- **Waveform Viewer:** EPWave
- **Language:** Verilog (IEEE 1364-2001)
