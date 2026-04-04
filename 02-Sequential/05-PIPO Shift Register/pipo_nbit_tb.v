//Testbench for N-Bit PIPO Shift Register
`timescale 1ns/1ps
module pipo_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk, reset;
  reg [(N-1):0] d;
  wire [(N-1):0] q;
  //2. DUT instantiation
  pipo_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.d(d),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile ("pipo_nbit_tb.vcd");
    $dumpvars(0,pipo_nbit_tb);
    //4.2 Display
    $display(" Time |    D   Rst | Q ");
    $display("------|------------|---");
    //4.3 Stimulus
    d=4'b0001; reset=1; #13; //Reset high
    d=4'b0001; reset=0; #10; //Reset low
    d=4'b0101; reset=0; #10; //Input change
    reset=1; #10;            //Reset High
    reset=0; #10;            //Reset low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b",$time,d,reset,q);
  end
endmodule
