//Testbench for Full Adder
`timescale 1ns/1ps
module fa_with_ha_tb();
  //1. Signal declaration
  reg a, b, cin;
  wire sum, cout;
  //2. DUT instantiation
  fa_with_ha dut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
  //3. Stimulus + Waveform
  initial begin
    //3.1 Waveform
    $dumpfile("fa_with_ha_tb.vcd");
    $dumpvars(0,fa_with_ha_tb);
    //3.2 Stimulus
    $display("Time | A B Cin | Sum  Cout |");
    $display("-----|---------|----------|");
    a=0; b=0; cin=0; #10;
    a=0; b=0; cin=1; #10;
    a=0; b=1; cin=0; #10;
    a=0; b=1; cin=1; #10;
    a=1; b=0; cin=0; #10;
    a=1; b=0; cin=1; #10;
    a=1; b=1; cin=0; #10;
    a=1; b=1; cin=1; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %b %b | %b   %b |", $time, a, b, cin, sum, cout);
  end
endmodule
