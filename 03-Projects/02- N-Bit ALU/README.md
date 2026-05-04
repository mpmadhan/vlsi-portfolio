# N-Bit ALU - Arithmetic Logic Unit

A parameterized N-bit ALU in Verilog supporting 16 operations across arithmetic,
logic, shift, rotate, comparison, and increment/decrement categories. Fully
combinational - result updates immediately with any change in inputs or select line.

## Modules

### alu_nbit
Single module. One combinational always block with a 16-case select statement.
Carry and zero flags computed alongside result.

## Ports

| Port     | Direction | Width  | Description                        |
|----------|-----------|--------|------------------------------------|
| `a`      | input     | N-bit  | Operand A                          |
| `b`      | input     | N-bit  | Operand B                          |
| `sel`    | input     | 4-bit  | Operation select (16 operations)   |
| `result` | output    | N-bit  | Operation result                   |
| `carry`  | output    | 1-bit  | Carry/borrow flag                  |
| `zero`   | output    | 1-bit  | HIGH when result is zero           |

## Operation Table

| `sel` | Operation       | Description              |
|-------|-----------------|--------------------------|
| `4'h0`| `A + B`         | Addition                 |
| `4'h1`| `A - B`         | Subtraction              |
| `4'h2`| `A & B`         | Bitwise AND              |
| `4'h3`| `A \| B`        | Bitwise OR               |
| `4'h4`| `A ^ B`         | Bitwise XOR              |
| `4'h5`| `~(A & B)`      | Bitwise NAND             |
| `4'h6`| `~(A \| B)`     | Bitwise NOR              |
| `4'h7`| `~(A ^ B)`      | Bitwise XNOR             |
| `4'h8`| `A << 1`        | Logical Shift Left       |
| `4'h9`| `A >> 1`        | Logical Shift Right      |
| `4'hA`| Rotate Left     | MSB wraps to LSB         |
| `4'hB`| Rotate Right    | LSB wraps to MSB         |
| `4'hC`| `A > B`         | Greater than comparison  |
| `4'hD`| `A == B`        | Equality comparison      |
| `4'hE`| `A + 1`         | Increment                |
| `4'hF`| `A - 1`         | Decrement                |

## How It Works

Purely combinational - `always @(*)` evaluates immediately on any input change.
Carry and zero default to `0` at the top of the block to prevent latches.
Zero flag is computed after the case statement - asserts whenever `result == 0`
regardless of operation.

Rotate operations use concatenation:
```verilog
Rotate Left:  {a[(N-2):0], a[N-1]}  // MSB wraps to LSB
Rotate Right: {a[0], a[(N-1):1]}    // LSB wraps to MSB
```

## Testbench Design

Input values are defined via macros for easy modification:
```verilog
`define A 4'b1011
`define B 4'b0110
```

Change these two lines to test any input combination across all 16 operations
without touching the stimulus block.

All 16 operations exercised sequentially with `#10` delay between each.
No clock needed - purely combinational DUT.

## Files

| File            | Description                                  |
|-----------------|----------------------------------------------|
| `alu_nbit.v`    | RTL - 16-operation parameterized ALU         |
| `alu_nbit_tb.v` | Testbench - all operations, macro-controlled |

## RTL Code

```verilog
//RTL Code for designing N-Bit ALU
/*sel:0: A+B, 1: A-B, 2: A&B, 3: A|B, 4: A^B, 5: ~(A&B), 6: ~(A|B), 7: ~(A^B), 8: Left Shift
  sel:9: Right Shift, A. Rotate Left, B. Rotate Right, C.A>B, D. A==B, E. A+1, F. A-1. 
  default: A+B*/
module alu_nbit #(parameter N=4)(
  input [(N-1):0] a,b,
  input [3:0] sel,
  output reg [(N-1):0] result,
  output reg carry,zero
);
  always @(*) begin
    carry=0; //initial values
    zero=0;
    case(sel)
      4'h0: {carry,result} = a+b;          //Addition
      4'h1: {carry,result} = a-b;          //Subtraction
      4'h2: result = a&b;                  //Bitwise AND
      4'h3: result = a|b;                  //Bitwise OR
      4'h4: result = a^b;                  //Bitwise XOR
      4'h5: result = ~(a&b);               //Bitwise NAND
      4'h6: result = ~(a|b);               //Bitwise NOR
      4'h7: result = ~(a^b);               //Bitwise XNOR
      4'h8: result = (a<<1);               //Shift Left
      4'h9: result = (a>>1);               //Shift Right 
      4'ha: result = {a[(N-2):0],a[N-1]};  //Rotate Left
      4'hb: result = {a[0],a[(N-1):1]};    //Rotate Right
      4'hc: result = (a>b)?1:0;            //Greater than comparison check
      4'hd: result = (a==b)?1:0;           //Equal to comparison
      4'he: result = a+1'b1;               //Increment operator
      4'hf: result = a-1'b1;               //Decrement operator
      default: {carry,result} = a+b;
    endcase
    if(!result)
      zero=1'b1;
  end
endmodule
```

## Testbench

```verilog
//Testbench for N-Bit ALU
/*sel:0: A+B, 1: A-B, 2: A&B, 3: A|B, 4: A^B, 5: ~(A&B), 6: ~(A|B), 7: ~(A^B), 8: Left Shift
  sel:9: Right Shift, A. Rotate Left, B. Rotate Right, C.A>B, D. A==B, E. A+1, F. A-1. 
  default: A+B*/
`timescale 1ns/1ns
`define A 4'b1011
`define B 4'b0110
module alu_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg [(N-1):0] a,b;
  reg [3:0] sel;
  wire [(N-1):0] result;
  wire carry,zero;
  //2. DUT instantiation
  alu_nbit #(.N(N)) dut(.a(a),.b(b),.sel(sel),.result(result),.carry(carry),.zero(zero));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("alu_nbit_tb.vcd");
    $dumpvars(0,alu_nbit_tb);
    //3.2 Display
    $display(" Time | A B Sel | Result Carry Zero");
    $display("------|---------|------------------");
    //3.3 Stimulus
    a=`A; b=`B;
    sel=4'h0; #10;    //Addition
    sel=4'h1; #10;    //Subtraction
    sel=4'h2; #10;    //Bitwise AND
    sel=4'h3; #10;    //Bitwise OR
    sel=4'h4; #10;    //Bitwise XOR
    sel=4'h5; #10;    //Bitwise NAND  
    sel=4'h6; #10;    //Bitwise NOR
    sel=4'h7; #10;    //Bitwise XNOR
    sel=4'h8; #10;    //Shift Left
    sel=4'h9; #10;    //Shift Right
    sel=4'ha; #10;    //Rotate Left
    sel=4'hb; #10;    //Rotate Right
    sel=4'hc; #10;    //Greater than comparison
    sel=4'hd; #10;    //Equal to Comparison
    sel=4'he; #10;    //Increment operator
    sel=4'hf; #10;    //Decrement operator
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b %b %b",$time,a,b,sel,result,carry,zero);
  end
endmodule
```

## Simulation

<img width="500" height="400" alt="image" src="https://github.com/user-attachments/assets/1f35897c-32b2-4605-a102-5bd69a56b7ac" />

<img width="1919" height="413" alt="image" src="https://github.com/user-attachments/assets/addaed37-54ef-40a0-94a5-ef37aae1d4d4" />

Simulated using EDA Playground. All 16 operations verified with A=1011, B=0110.
Carry flag verified on addition overflow. Zero flag behavior confirmed.
Macro-based input control validated - single point of change for all test vectors.

## Key Concepts Demonstrated

- 16-operation ALU - arithmetic, logic, shift, rotate, compare, increment/decrement
- Parameterized width - scales to any N-bit operand size
- Latch prevention - carry, zero defaulted to 0 before case statement
- Rotate via concatenation - no shift operator needed
- `\`define` macros - single point input control for clean testbench management

## Tools

- **Simulator:** EDA Playground (Icarus Verilog)
- **Waveform Viewer:** EPWave
- **Language:** Verilog (IEEE 1364-2001)
