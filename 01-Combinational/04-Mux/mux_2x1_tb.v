//Testbench for 2x1 Multiplexor
`timescale 1ns/1ps
module mux_2x1_tb();
  //1. Signal declaration
  reg a,b,sel;
  wire y;
  //2. DUT instantiation
  mux_2x1 dut(.a(a),.b(b),.sel(sel),.y(y));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("mux_2x1_tb.vcd");
    $dumpvars(0,mux_2x1_tb);
    //3.2 Display
    $display(" Time | A B Sel | Output ");
    $display("------|---------|--------");
    //3.3 Stimulus
    a=0;b=0;sel=0; #10;
    a=0;b=0;sel=1; #10;
    a=0;b=1;sel=0; #10;
    a=0;b=1;sel=1; #10;
    a=1;b=0;sel=0; #10;
    a=1;b=0;sel=1; #10;
    a=1;b=1;sel=0; #10;
    a=1;b=1;sel=1; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor(" %4t | %b %b %b | %b ",$time,a,b,sel,y);
  end
endmodule
