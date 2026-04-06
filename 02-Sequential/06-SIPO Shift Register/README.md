# SIPO - Serial In Parallel Out Shift Register

A SIPO register accepts data one bit at a time serially and shifts it through
the register on every rising clock edge. After N clock cycles, all N bits are
available simultaneously at the parallel output. It is commonly used in serial
to parallel data conversion - a classic example being a UART receiver.

## Module

### sipo_nbit - N-bit SIPO
Parameterized N-bit serial in parallel out shift register.
Default width is 4. Data shifts in MSB first from the serial input.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| reset | input | 1-bit | Active high synchronous reset |
| d | input | 1-bit | Serial data input |
| q | output | N-bit | Parallel data output |

## How It Works
```
On every posedge clk:
if reset → Q = 0
else     → Q = {Q[N-2:0], d}  (left shift, new bit enters at LSB)
After N clock cycles, Q contains the full N-bit serial pattern.
Example for N=4, serial_data = 1011:
Cycle 1: d=1 → Q = 0001
Cycle 2: d=0 → Q = 0010
Cycle 3: d=1 → Q = 0101
Cycle 4: d=1 → Q = 1011 ✅
```

## Files

| File | Description |
|------|-------------|
| sipo_nbit.v | Parameterized N-bit SIPO shift register |
| sipo_nbit_tb.v | Testbench using for loop to shift in MSB first |

## RTL Code
```verilog
//RTL Code for N-Bit Serial In Parallel Out Shift Register
module sipo_nbit #(parameter N=4)(
  input clk, reset,
  input d,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q <= 0;
    else
      q <= {q[N-2:0], d};     // Left shift - new bit enters at LSB
    //q <= {d, q[N-1:1]};     // Right shift - new bit enters at MSB
  end
endmodule
```

## Testbench
```verilog
//Testbench for N-Bit Serial In Parallel Out Shift Register
`timescale 1ns/1ps
module sipo_nbit_tb();
  //1. Signal declaration
  localparam N=4;
  reg clk, reset;
  reg d;
  reg [(N-1):0] serial_data;
  wire [(N-1):0] q;
  integer i;
  //2. DUT instantiation
  sipo_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.d(d),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("sipo_nbit_tb.vcd");
    $dumpvars(0,sipo_nbit_tb);
    //4.2 Display
    $display(" Time | D Rst | Q");
    $display("------|-------|---");
    //4.3 Stimulus
    serial_data = 'b1011;
    d=0;reset=1; #12; //reset high
    reset=0; #10; //reset low
    for (i=N-1;i>=0;i=i-1) begin
      d = serial_data[i]; #10; //i=3,2,1,0 MSB first
    end
    reset=1; #10;     //reset high
    d=0;reset=0; #10; //reset low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,d,reset,q);
  end
endmodule
```

## Simulation

<img width="300" height="450" alt="image" src="https://github.com/user-attachments/assets/3c29ef89-c0e6-42a2-8077-3e1cce03ea15" />

<img width="1919" height="397" alt="image" src="https://github.com/user-attachments/assets/68fccf40-50af-4986-8715-8701320e0d5d" />

Simulated using EDA Playground. Serial pattern 1011 shifted in MSB first
over 4 clock cycles. Output Q confirmed to equal 1011 after N cycles.
