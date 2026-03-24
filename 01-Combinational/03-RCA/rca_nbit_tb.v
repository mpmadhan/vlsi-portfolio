//Testbench for N-bit Ripple Carry Adder
`timescale 1ns/1ps
module rca_nbit_tb();
  //1. Signal declaration
  localparam WIDTH = 4;

  reg [(WIDTH-1):0] a,b;
  reg cin;
  wire [(WIDTH-1):0] sum;
  wire cout;
  //2. DUT instantiation
  rca_nbit #(.WIDTH(WIDTH)) dut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("rca_nbit_tb.vcd");
    $dumpvars(0,rca_nbit_tb);
    //3.2 Stimulus
    $display("| T | A B Cin | Sum Cout |");
    $display("|---|---------|----------|");

    a=4'd0;b=4'd0;cin=0; #10; //0+0+0 = 0
    a=4'd3;b=4'd4;cin=1; #10; //3+4+1 = 8
    a=4'd5;b=4'd10;cin=1; #10; //5+10+1 = 16 overflow
    a=4'd15;b=4'd15;cin=1; #10; //15+15+1 = 31 overflow
    $finish;
  end
  //4.Observation
  initial begin
    $monitor("| %4t | %4b %4b %b | %4b %b |",$time,a,b,cin,sum,cout);
  end
endmodule
