//Testbench for Mod-N Counter
`timescale 1ns/1ps
module modn_counter_tb();
  //1. Signal Declaration
  localparam N = 4;
  localparam M = 10;    //MOD-N, N-value
  reg clk,reset,enable;
  wire [(N-1):0] q;
  //2. DUT instantitaion
  modn_counter #(.N(N),.M(M)) dut(.clk(clk),.reset(reset),.enable(enable),.q(q));
  //3. Clock Generation
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("modn_counter_tb.vcd");
    $dumpvars(0,modn_counter_tb);
    //4.2 Display
    $display("Output for the values of M=%d and N=%d",M,N);
    $display(" Time | Rst En | Q ");
    $display("------|--------|---");
    //4.3 Stimulus
    reset=1; enable=0; #13; //Initial values
    enable=1; #10;          //enable high
    reset=0; #10;           //Reset low
    repeat(M+2)             //M+2 to check resetting value
      @(posedge clk);
    reset=1; #10;
    reset=0; #10;
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,reset,enable,q);
  end
endmodule
