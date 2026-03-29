//Testbench 3x8 Decoder
`timescale 1ns/1ps
module decoder_3x8_tb();
  //1. Signal declaration
  reg [2:0] in;
  wire [7:0] out;
  integer i;
  //2. DUT instantiation
  decoder_3x8 dut(.in(in),.out(out));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("decoder_3x8_tb.vcd");
    $dumpvars(0,decoder_3x8_tb);
    //3.2 Display
    $display("Time |   In   |   Out   ");
    $display("-----|--------|---------");
    //3.3 Stimulus
    for(i=0;i<8;i=i+1) begin
      in = i; #10;
    end
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t |   %3b   |   %8b   ",$time,in,out);
  end
endmodule
