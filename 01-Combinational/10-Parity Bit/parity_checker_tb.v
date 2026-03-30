//Testbench for 4-Bit Parity Checker
`timescale 1ns/1ps
module parity_checker_tb();
  //1. Signal Declaration
  reg [3:0] d;
  reg parity;
  wire error;
  integer i,j;
  //2. Dut Instantiation
  parity_checker dut(.d(d),.parity(parity),.error(error));
  //3. Waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile("parity_checker_tb.vcd");
    $dumpvars(0,parity_checker_tb);
    //3.2 Display
    $display("Time |  D  Parity | Error");
    $display("-----|------------|------");
    //3.3 Stimulus
    for(i=0;i<16;i=i+1) begin
      d = i;
      for(j=0;j<2;j=j+1) begin
        parity = j; #10;
      end
    end
  end
  //4. Observation
  initial begin
    $monitor("%4t | %4b  %b | %b",$time,d,parity,error);
  end
endmodule
    
