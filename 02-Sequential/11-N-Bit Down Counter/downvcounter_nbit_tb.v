//Testbench for N-Bit DOWN Counter
`timescale 1ns/1ps
module downcounter_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk, reset, enable;
  wire [(N-1):0] q;
  //2. DUT instantiation
  downcounter_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.enable(enable),.q(q));
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform & Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("upcounter_nbit_tb.vcd");
    $dumpvars(0,upcounter_nbit_tb);
    //4.2 Display
    $display(" Time | Rst En |   Q   ");
    $display("------|--------|-------");
    //4.3 Stimulus
    reset=1;enable=0; #13; //Reset High
    enable=1; #10;         //Enable high but reset high
    reset=0; #10;          //Reset low
    repeat(1<<N)           //2 power N
      @(posedge clk);
    repeat(3)
      @(posedge clk);      //To check whether it is reverting back to 0000 after all bits high
    reset=1; #20;          //Checking reset case
    reset=0; #10;          //Removing reset
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,reset,enable,q);
  end
endmodule
