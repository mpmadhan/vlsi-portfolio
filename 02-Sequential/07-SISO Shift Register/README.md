# SISO - Serial In Serial Out Shift Register

A SISO shift register accepts data one bit at a time and outputs it one bit
at a time after a delay of N clock cycles. It acts as a digital delay line -
whatever goes in comes out exactly N cycles later. It is used in data
synchronization, delay buffers, and communication pipelines.

## Module

### siso_nbit - N-bit SISO
Parameterized N-bit serial in serial out shift register.
Default width is 4. Data shifts in MSB first and exits from MSB after N cycles.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| reset | input | 1-bit | Active high synchronous reset |
| d | input | 1-bit | Serial data input |
| q | output | 1-bit | Serial data output (delayed by N cycles) |

## How It Works
```Internal shift register shifts left on every posedge clk:
shift_reg <= {shift_reg[N-2:0], d}
Serial output is the MSB of the internal register:
q = shift_reg[N-1]
Example for N=4, serial_data = 1011:
Cycle 1: d=1 → shift_reg = 0001, q = 0
Cycle 2: d=0 → shift_reg = 0010, q = 0
Cycle 3: d=1 → shift_reg = 0101, q = 0
Cycle 4: d=1 → shift_reg = 1011, q = 1 ← first bit appears
Cycle 5: d=0 → shift_reg = 0110, q = 0
Cycle 6: d=0 → shift_reg = 1100, q = 1 (wrong, just flushing)
```
## Files

| File | Description |
|------|-------------|
| siso_nbit.v | Parameterized N-bit SISO shift register |
| siso_nbit_tb.v | Testbench using for loop and repeat to verify N cycle delay |

## RTL Code
```verilog
//RTL Code for N-Bit Serial IN Serial OUT Shift Register
module siso_nbit #(parameter N=4)(
  input clk, reset,
  input d,
  output q
);
  reg [(N-1):0] shift_reg;
  always @(posedge clk) begin
    if(reset)
      shift_reg <= 0;
    else
      shift_reg <= {shift_reg[(N-2):0],d}; //Right shift
    //shift_reg <= {d,shift_reg[(N-1):1]}  //Left Shift
  end
  assign q = shift_reg[N-1];
endmodule
```

## Testbench
```verilog
//Testbench for N-Bit Serial IN Serial OUT Shift Register
`timescale 1ns/1ps
module siso_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk, reset;
  reg d;
  reg [(N-1):0] serial_data;
  wire q;
  integer i;
  //2. DUT instantiation
  siso_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.d(d),.q(q));
  //3. Clock Generation
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("siso_nbit_tb.vcd");
    $dumpvars(0,siso_nbit_tb);
    //4.2 Display
    $display(" Time | D Rst | Q ");
    $display("------|-------|---");
    //4.3 Stimulus
    serial_data = 'b1011;
    reset=1;d='1; #12; //Reset High
    reset=0; #10;      //Reset low
    for(i=N-1;i>=0;i=i-1) begin
      d=serial_data[i]; #10; //Input High
    end
    repeat(N) begin
      d=0; #10;
    end
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,d,reset,q);
  end
endmodule
```

## Simulation

<img width="300" height="450" alt="image" src="https://github.com/user-attachments/assets/4d2cef11-1731-479e-aeaa-ef6531582c84" />

<img width="1912" height="504" alt="image" src="https://github.com/user-attachments/assets/4bcc0593-1233-436b-87d7-aaece6b36e90" />

Simulated using EDA Playground. Serial pattern 1011 shifted in MSB first
over 4 clock cycles. Output q confirmed to produce delayed serial output
after N clock cycles.
