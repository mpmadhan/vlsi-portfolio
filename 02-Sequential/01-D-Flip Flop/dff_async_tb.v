//Testbench for Asynchronous D-Flip Flop
`timescale 1ns/1ps
module dff_async_tb();
  //1. Signal Declaration
  reg clk,d,reset;
  wire q;
  //2. DUT instantiation
  dff_async dut(.clk(clk),.d(d),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("dff_async_tb.vcd");
    $dumpvars(0,dff_async_tb);
    //4.2 Display
    $display(" Time | Clk D Rst | Q ");
    $display("------|-----------|---");
    //4.3 Stimulus
    reset=1; d=0;     //applying reset
    #13 reset=0;d=1;  //Removing reset and input high
    #10 reset=1;      //applying reset
    #10 reset=0;      //removing reset
    #10 d=0;          //input low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b",$time,clk,d,reset,q);
  end
endmodule
