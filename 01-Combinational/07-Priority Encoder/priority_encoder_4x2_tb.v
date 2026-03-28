//Testbench for 4x2 Priority Encoder
`timescale 1ns/1ps
module priority_encoder_4x2_tb();
  //1. Signal declaration
  reg [3:0] in;
  wire [1:0] out;
  wire valid;
  integer i;
  //2. DUT instantiation
  priority_encoder_4x2 dut(.in(in),.out(out),.valid(valid));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile ("priority_encoder_4x2_tb.vcd");
    $dumpvars (0,priority_encoder_4x2_tb);
    //3.2 Display
    $display ("Time  |   In   |  Out  | Valid");
    $display ("------|--------|-------|------");
    //3.3 Stimulus
    in=4'b0000;
    for (i=0;i<=15;i=i+1) begin
      in = i; #10;
    end
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t  |   %4b   |  %2b  | %b",$time,in,out,valid);
  end
endmodule
