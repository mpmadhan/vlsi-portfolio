//Testbench for SR Flip Flop
`timescale 1ns/1ps
module srff_tb();
  //1. Signal Declaration
  reg clk, s, r, reset;
  wire q;
  //2. DUT instantiation
  srff dut(.clk(clk),.s(s),.r(r),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("srff_tb.vcd");
    $dumpvars(0,srff_tb);
    //4.2 Display
    $display("Time | Clk S R Rst | Q ");
    $display("-----|-------------|---");
    //4.3 Stimulus
    s=0;r=0;reset=1; #10; //Reset High
    s=0;r=1;reset=0; #10; //Reset low and SR reset
    s=1;r=0;reset=0; #10; //SR Set
    s=1;r=0;reset=1; #10; //Reset high
    s=1;r=0;reset=0; #10; //Reset low
    s=1;r=1;reset=0; #10; //Invalid condition
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b %b | %b",$time,clk,s,r,reset,q);
  end
endmodule
