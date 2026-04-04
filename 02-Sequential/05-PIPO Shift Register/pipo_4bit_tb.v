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
    d=4'b0000; reset=1; #10; //Reset High
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
