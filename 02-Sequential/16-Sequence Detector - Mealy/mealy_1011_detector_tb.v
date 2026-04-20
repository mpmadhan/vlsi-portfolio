//Testbench for Mealy Sequence Detector - 1011
`timescale 1ns/1ps
module mealy_1011_detector_tb();
  //1. Signal Declaration
  reg clk,reset,din;
  wire q;
  //2. DUT instantiation
  mealy_1011_detector dut(.clk(clk),.reset(reset),.din(din),.(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("mealy_1011_detector_vcd");
    $dumpvars(0,mealy_1011+detector);
    //4.2 Display
    $display(" Time | Rst Din | Q");
    $display("------|---------|---");
  end
  //4.3 Stimulus
  initial begin
    reset=1; din=0; //initial values
    #10;
    reset=0; #10; //Reset low
    //1011 Testing
    @(posedge clk) din=1;
    @(posedge clk) din=0; 
    @(posedge clk) din=1;
    @(posedge clk) din=1;
    //Overlapping teset
    @(posedge clk) din=0;
    @(posedge clk) din=1;
    @(posedge clk) din=1;
    //Mid-reset test
    @(posedge clk) din=1;
    @(posedge clk) reset=1;
    @(posedge clk) reset=0;
    //1011 testing for 3 cycles
    repeat(3) begin
      @(posedge clk) din=1;
      @(posedge clk) din=0; 
      @(posedge clk) din=1;
      @(posedge clk) din=1;
    end
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,reset,din,q);
  end
endmodule
