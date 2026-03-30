//Testbench for 4-Bit Comparator
`timescale 1ns/1ps
module comparator_4bit_tb();
  //1. Signal Declaration
  reg [3:0] a,b;
  wire eq,gt,lt;
  integer i,j;
  //2. DUT instantiation
  comparator_4bit dut(.a(a),.b(b),.eq(eq),.gt(gt),.lt(lt));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("comparator_4bit_tb.vcd");
    $dumpvars(0,comparator_4bit_tb);
    //3.2 Display
    $display("Time |  A   B  | A>B A=B A<B ");
    $display("-----|---------|-------------");
    //3.3 Stimulus
    for(i=0;i<16;i=i+1) begin
      a = i;
      for(j=0;j<16;j=j+1) begin
        b = j; #10;
      end
    end
    $finish;  
  end
  //4. Observation
  initial begin
    $monitor("%4t | %4b  %4b  | %b %b %b",$time,a,b,gt,eq,lt);
  end
endmodule
      
