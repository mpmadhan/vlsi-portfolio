//Testbench for N-bit Comparator
`timescale 1ns/1ps
module comparator_nbit_tb();
  //1. Signal Declaration
  localparam N = 4;
  reg [(N-1):0] a,b;
  wire eq,gt,lt;
  integer i,j;
  //2. Dut instantiation
  comparator_nbit #(.N(N)) dut(.a(a),.b(b),.eq(eq),.gt(gt),.lt(lt));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("comparator_nbit_tb.vcd");
    $dumpvars(0,comparator_nbit_tb);
    //3.2 Display
    $display("Time | A  B | A>B A=B A<B");
    $display("-----|------|------------");
    //3.3 Stimulus
    for(i=0;i<(1<<N);i=i+1) begin //N^2
      a = i;
      for(j=0;j<(1<<N);j=j+1) begin
        b = j; #10;
      end
    end
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %b  %b | %b %b %b",$time,a,b,gt,eq,lt);
  end
endmodule
