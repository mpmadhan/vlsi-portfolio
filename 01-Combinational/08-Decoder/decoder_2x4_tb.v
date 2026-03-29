//Testbench for 2x4 Decoder
`timescale 1ns/1ps
module decoder_2x4_tb();
  //1. Signal Declaration
  reg [1:0] in;
  wire [3:0] out;
  integer i;
  //2. DUT instantiation
  decoder_2x4 dut(.in(in),.out(out));
  //3. Waveform + Stimukus
  initial begin
    //3.1 Waveform
    $dumpfile ("decoder_2x4_tb.vcd");
    $dumpvars (0,decoder_2x4_tb);
    //3.2 Display
    $display("Time |  In  |  Out  ");
    $display("-----|------|-------");
    //3.3 Stimulus
    for (i=0;i<4;i=i+1) begin
      in = i; #10;
    end
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t |  %2b  |  %4b  ",$time,in,out);
  end
endmodule
