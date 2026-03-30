//Testbench for 4-Bit Parity Generator
`timescale 1ns/1ps
module parity_generator_tb();
  //1. Signal declaration
  reg [3:0] d;
  wire parity;
  integer i;
  //2. DUT instantiation
  parity_generator dut(.d(d),.parity(parity));
  //3. waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile ("parity_generator_tb.vcd");
    $dumpvars (0,parity_generator_tb);
    //3.2 Display
    $display("Time |  D  | Parity");
    $display("-----|-----|-------");
    //3.3 Stimulus
    for (i=0;i<16;i=i+1) begin
      d=i; #10;
    end
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %4b | %b",$time,d,parity);
  end
endmodule
