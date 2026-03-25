//Testbench for 4x1 Multiplexor
`timescale 1ns/1ps
module mux_4x1_tb();
  //1. Signal declaration
  reg i0,i1,i2,i3;
  reg [1:0] sel;
  wire y;
  //2. DUT Instantiation
  mux_4x1 dut(.i0(i0),.i1(i1),.i2(i2),.i3(i3),.sel(sel),.y(y));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("mux_4x1_tb.vcd");
    $dumpvars(0,mux_4x1_tb);
    //3.2 Display
    $display("Time | I0 I1 I2 I3 | S1 S0 | Output");
    $display("-----|-------------|-------|-------");
    //3.3 Stimulus
    i0=0; i1=1; i2=0; i3=1; 
    sel=2'b00; #10;
    sel=2'b01; #10;
    sel=2'b10; #10;
    sel=2'b11; #10;
    i0=1; i1=0; i2=1; i3=0;
    sel=2'b00; #10;
    sel=2'b01; #10;
    sel=2'b10; #10;
    sel=2'b11; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %b %b %b |  %2b  | %b",$time,i0,i1,i2,i3,sel,y);
  end
endmodule
