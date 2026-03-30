//Testbench for N-Bit Parity Generator
`timescale 1ns/1ps
module parity_generator_nbit_tb();
  //1. Signal declaration
  localparam N=4;
  reg [(N-1):0] d;
  wire parity;
  integer i;
  //2. DUT instantiation
  parity_generator_nbit #(.N(N)) dut(.d(d),.parity(parity));
  //3. waveform + Stimulus
  initial begin
    //3.1 Waveform
    $dumpfile ("parity_generator_nbit_tb.vcd");
    $dumpvars (0,parity_generator_nbit_tb);
    //3.2 Display
    $display("Time |  D  | Parity");
    $display("-----|-----|-------");
    //3.3 Stimulus
    for (i=0;i<(1<<N);i=i+1) begin
      d=i; #10;
    end
    $finish;
  end
  //4. Observation
  initial begin
    $monitor("%4t | %4b | %b",$time,d,parity);
  end
endmodule
