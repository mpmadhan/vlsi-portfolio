//Testbench for 1x2 Demux
`timescale 1ns/1ps
module demux_1x2_tb();
  //1. Signal declaration
  reg in,sel;
  wire y0,y1;
  //2. DUT Instantiation
  demux_1x2 dut(.in(in),.sel(sel),.y0(y0),.y1(y1));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("demux_1x2_tb.vcd");
    $dumpvars(0,demux_1x2_tb);
    //3.2 Display
    $display("Time | In Sel | Y0 Y1");
    $display("-----|--------|------");
    //3.3 Stimulus
    in=0; sel=0; #10;
    in=0; sel=1; #10;
    in=1; sel=0; #10;
    in=1; sel=1; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %b | %b %b",$time,in,sel,y0,y1);
  end
endmodule
