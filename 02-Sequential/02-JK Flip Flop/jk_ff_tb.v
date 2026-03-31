//Testbench for JK Flip flop
`timescale 1ns/1ps
module jk_ff_tb();
  //1. Signal Declaration
  reg clk, j, k, reset;
  wire q;
  //2. DUT Instantiation
  jk_ff dut(.clk(clk),.j(j),.k(k),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Wavefomr
    $dumpfile("jk_ff_tb.vcd");
    $dumpvars(0,jk_ff_tb);
    //4.2 Display
    $display("Time | J K Rst | Q");
    $display("-----|---------|---");
    //4.3 Stimulus
    j=0;k=0;reset=1; #12; //reset high
    j=1;k=0; #10;         //set but reset high
    reset=0; #10;         //reset removed
    j=0;k=0; #10;         //memory
    j=0;k=1; #10;         //reset
    j=1;k=1; #10;         //toggle
    j=0;k=0; #10;         //memory
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b",$time,j,k,reset,q);
  end
endmodule
