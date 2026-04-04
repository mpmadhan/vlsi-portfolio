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
    d=0; reset=1; #12; //All data bits low, reset High
    d=1; reset=0; #10; //LSB is set high
    d=(1<<(N-1)); #10; //MSB set high
    d='1; #10;         //All bits high
    reset=1; #10;      //Reset High
    reset=0; #10;      //Reset Low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b",$time,d,reset,q);
  end
endmodule
