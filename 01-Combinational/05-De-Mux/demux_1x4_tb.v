//Testbench for 1x4 Demux
`timescale 1ns/1ps
module demux_1x4_tb();
  //1. Signal declaration
  reg in;
  reg [1:0] sel;
  wire y0,y1,y2,y3;
  //2. DUT instantiation
  demux_1x4 dut(.in(in),.sel(sel),.y0(y0),.y1(y1),.y2(y2),.y3(y3));
  //3. Waveform ++ Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("demux_1x4_tb.vcd");
    $dumpfile(0,demux_1x4_tb);
    //3.2 Display
    $display("Time | In Sel | Y0 Y1 Y2 Y3");
    $display("-----|--------|------------");
    //3.3 Stimulus
    in=0; sel=2'b00; #10;
    in=0; sel=2'b01; #10;
    in=0; sel=2'b10; #10;
    in=0; sel=2'b11; #10;
    in=1; sel=2'b00; #10;
    in=1; sel=2'b01; #10;
    in=1; sel=2'b10; #10;
    in=1; sel=2'b11; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %2b | %b %b %b %b",$time,in,sel,y0,y1,y2,y3);
  end
endmodule
