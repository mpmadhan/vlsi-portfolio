//Testbench for 4x2 Encoder
`timescale 1ns/1ps
module encoder_4x2_tb();
  //1. Signal declaration
  reg [3:0] i;
  wire [1:0] y;
  //2. DUT instantiation
  encoder_4x2 dut(.i(i),.y(y));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("encoder_4x2_tb.vcd");
    $dumpvars(0,encoder_4x2_tb);
    //3.2 Display
    $display("Time |   I   |   Y   ");
    $display("-----|-------|-------");
    //3.3 Stimulus
    i=4'b0001; #10;
    i=4'b0010; #10;
    i=4'b0100; #10;
    i=4'b1000; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %4b | %2b ",$time,i,y);
  end
endmodule
