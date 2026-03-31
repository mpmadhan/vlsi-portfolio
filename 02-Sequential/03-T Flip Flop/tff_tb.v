//Testbench for T Flip Flop
`timescale 1ns/1ps
module tff_tb();
  //1. Signal Declaration
  reg clk, t, reset;
  wire q;
  //2. DUT instantiation
  tff dut(.clk(clk),.t(t),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("tff_tb.vcd");
    $dumpvars(0,tff_tb);
    //4.2 Display
    $display(" Time | Clk T Rst | Q");
    $display("------|-----------|---");
    //4.3 Stimulus
    reset=1;t=0; #13; //Reset high
    t=1; #10;         //input high when reset high
    reset=0; #10;     //Reset low
    t=0; #10;         //input low
    t=1; #10;         //input high (output toggles)
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b",$time,clk,t,reset,q);
  end
endmodule
    
