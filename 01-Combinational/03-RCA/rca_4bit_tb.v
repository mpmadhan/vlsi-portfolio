//Testbench for 4-bit Ripple Carry Adder
`timescale 1ns/1ps
module rca_4bit_tb();
  //1.Signal declaration
  reg [4:0] a,b;
  reg cin;
  wire [4:0] sum;
  wire cout;
  //2.DUT instantiation
  rca_4bit dut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
  //3.Stimulus
  initial begin
    #10;
    a=0;b=0;cin=0; #10;
    a=0;b=0;cin=1; #10;
    a=0;b=1;cin=0; #10;
    a=0;b=1;cin=1; #10;
    a=1;b=0;cin=0; #10;
    a=1;b=0;cin=1; #10;
    a=1;b=1;cin=0; #10;
    a=1;b=1;cin=1; #10;
    #100 $finish;
  end
endmodule
