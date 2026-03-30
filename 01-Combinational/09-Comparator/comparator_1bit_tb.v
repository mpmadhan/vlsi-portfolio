//Testbench for 1-Bit Comparator
`timescale 1ns/1ps
module comparator_1bit_tb();
  //1. Signal Declaration
  reg a,b;
  wire eq,gt,lt;
  //2. DUT instantitation
  comparator_1bit dut(.a(a),.b(b),.eq(eq),.gt(gt),.lt(lt));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile ("comparator_1bit_tb.vcd");
    $dumpvars (0,comparator_1bit_tb);
    //3.2 Display
    $display ("Time | A B | A>B A=B A<B");
    $display ("-----|-----|------------");
    //3.3 Stimulus
    a=0; b=0; #10;
    a=0; b=1; #10;
    a=1; b=0; #10;
    a=1; b=1; #10;
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b %b | %b %b %b",$time,a,b,gt,eq,lt);
  end
endmodule
