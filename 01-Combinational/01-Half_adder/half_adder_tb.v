//Testbench for Half Adder
`timescale 1ns/1ps
module half_adder_tb();
  //1. Signal declaration
  reg a, b;
  wire sum, cout;
  //2. DUT instantiation
  half_adder dut(.a(a), .b(b), .sum(sum), .cout(cout));
  //3. Stimulus + Waveform
  initial begin
    //3.1 Waveform Generation
    $dumpfile("half_adder_tb.vcd");
    $dumpvars(0,half_adder_tb);
    //3.2 Stimulus
    $display("Time | A B | Sum Cout");
    $display("-----|-----|---------");
    a=0; b=0; #10;
    a=0; b=1; #10;
    a=1; b=0; #10;
    a=1; b=1; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %b |  %b   %b", $time, a, b, sum, cout);
  end
  
endmodule
