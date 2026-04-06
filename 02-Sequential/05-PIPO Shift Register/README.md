# PIPO - Parallel In Parallel Out Register

A PIPO register loads all input bits simultaneously on the rising clock edge
and presents all output bits simultaneously. It is essentially N D Flip Flops
working in parallel - no shifting is involved. It is the simplest form of a
register and is used for temporary data storage and pipeline staging.

## Modules

### pipo_4bit - 4-bit PIPO
Fixed 4-bit parallel register.

### pipo_nbit - N-bit PIPO
Parameterized version that works for any bit width.
Default width is 4.

## Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk | input | 1-bit | Clock signal |
| reset | input | 1-bit | Active high synchronous reset |
| d | input | N-bit | Parallel data input |
| q | output | N-bit | Parallel data output |

## How It Works
```
On every posedge clk:
if reset → Q = 0
else     → Q = D (all bits loaded simultaneously)
```
## Files

| File | Description |
|------|-------------|
| pipo_4bit.v | 4-bit PIPO register |
| pipo_4bit_tb.v | Testbench for 4-bit PIPO |
| pipo_nbit.v | Parameterized N-bit PIPO register |
| pipo_nbit_tb.v | Testbench using fill literals and shift for any N |

## RTL Code

### pipo_4bit
```verilog
//RTL Code for 4-Bit Parallel In Parallel Out Shift Register
module pipo_4bit(
  input clk, reset,
  input [3:0] d,
  output reg [3:0] q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else
      q<=d;
  end
endmodule
```

### pipo_nbit
```verilog
//RTL Code for N-Bit PIPO Shift Register
module pipo_nbit #(parameter N=4)(
  input clk, reset,
  input [(N-1):0] d,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else
      q<=d;
  end
endmodule
```

## Testbench

### pipo_4bit
```verilog
//Testbench for 4-bit Parallel In Parallel Out Shift Register
`timescale 1ns/1ps
module pipo_4bit_tb();
  //1. Signal Declaration
  reg clk, reset;
  reg [3:0] d;
  wire [3:0] q;
  //2. DUT instantiation
  pipo_4bit dut(.clk(clk),.reset(reset),.d(d),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("pipo_4bit_tb.vcd");
    $dumpvars(0,pipo_4bit_tb);
    //4.2 Display
    $display("Time |   D    Rst |   Q   ");
    $display("-----|------------|-------");
    //4.3 Stimulus
    d=4'b0000; reset=1; #12; //Reset High
    d=4'b0011; reset=1; #10; //Reset still High
    d=4'b0011; reset=0; #10; //Reset low
    d=4'b1010; reset=0; #10; //Input change
    reset=1; #10;            //Reset high
    reset=0; #10;            //Reset Low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b",$time,d,reset,q);
  end
endmodule
```

### pipo_nbit
```verilog
//Testbench for N-Bit PIPO Shift Register
`timescale 1ns/1ps
module pipo_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk, reset;
  reg [(N-1):0] d;
  wire [(N-1):0] q;
  //2. DUT instantiation
  pipo_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.d(d),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile ("pipo_nbit_tb.vcd");
    $dumpvars(0,pipo_nbit_tb);
    //4.2 Display
    $display(" Time |    D   Rst | Q ");
    $display("------|------------|---");
    //4.3 Stimulus
    d=0; reset=1; #12; //All data bits low, reset High
    d=1; reset=0; #10; //LSB is set high
    d=(1<<(N-1)); #10; //MSB set high
    d='1; #10;         //All bits high
    reset=1; #10;      //Reset High
    reset=0; #10;      //Reset Low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b",$time,d,reset,q);
  end
endmodule
```

## Simulation

### pipo_4bit

<img width="300" height="450" alt="image" src="https://github.com/user-attachments/assets/35b3d9ff-65d0-4187-825e-03bb55893886" />

<img width="1918" height="565" alt="image" src="https://github.com/user-attachments/assets/1acb2cf2-7d7c-4584-8ab2-34a48a70378f" />

### pipo_nbit

<img width="300" height="450" alt="image" src="https://github.com/user-attachments/assets/59f5daf3-2191-47ea-9bba-bd80b575c215" />

<img width="1919" height="592" alt="image" src="https://github.com/user-attachments/assets/68ecc8bf-eb80-4694-818a-f93dc83ca0fc" />

Simulated using EDA Playground. Parallel loading verified -
output Q matches input D on every rising clock edge.
Reset behavior confirmed.
