//Testbench for 8x3 Encoder
`timescale 1ns/1ps
module encoder_8x3_tb();
  //1. Signal Declaration
  reg [7:0] in;
  wire [2:0] out;
  //2. DUT instantiation
  encoder_8x3 dut(.in(in),.out(out));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveforem
    $dumpfile("encoder_8x3_tb.vcd");
    $dumpvars(0,encoder_8x3_tb);
    //3.2 Display
    $display("Time |    IN    |   OUT   ");
    $display("-----|----------|---------");
    //3.3 Stimulus
    in = 8'b00000001; #10;
    in = 8'b00000010; #10;
    in = 8'b00000100; #10;
    in = 8'b00001000; #10;
    in = 8'b00010000; #10;
    in = 8'b00100000; #10;
    in = 8'b01000000; #10;
    in = 8'b10000000; #10;
    $finish;
  end
  //4. Observation 
  initial begin
    $monitor("%4t | %8b | %3b",$time,in,out);
  end
endmodule
