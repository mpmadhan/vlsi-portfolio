//Testbench for N-Bit Serial In Parallel Out Shift Register
`timescale 1ns/1ps
module sipo_nbit_tb();
  //1. Signal declaration
  localparam N=4;
  reg clk, reset;
  reg d;
  wire [(N-1):0] q;
  //2. DUT instantiation
  sipo_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.d(d),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("sipo_nbit_tb.vcd");
    $dumpvars(0,sipo_nbit_tb);
    //4.2 Dispaly
    $display(" Time | D Rst | Q");
    $display("------|-------|---");
    //4.3 Stimulus
    d=0;reset=1; #10; //reset high
    d=1;reset=0; #10; //reset low
    d=0; #10;         //input change
    d=1; #10;         //input change
    reset=1; #10;     //reset high
    d=1;reset=0; #10; //reset low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,d,reset,q);
  end
endmodule
