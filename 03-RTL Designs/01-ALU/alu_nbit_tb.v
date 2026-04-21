//Testbench for N-Bit ALU
/*sel:0: A+B, 1: A-B, 2: A&B, 3: A|B, 4: A^B, 5: ~(A&B), 6: ~(A|B), 7: ~(A^B), 8: Left Shift
  sel:9: Right Shift, A. Rotate Left, B. Rotate Right, C.A>B, D. A==B, E. A+1, F. A-1. 
  default: A+B*/
`timescale 1ns/1ns
`define a 4'1011
`define b 4'0110
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
    a=4'b1011; b=4'0110;
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
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b %b %b",$time,a,b,sel,result,carry,zero);
  end
endmodule
