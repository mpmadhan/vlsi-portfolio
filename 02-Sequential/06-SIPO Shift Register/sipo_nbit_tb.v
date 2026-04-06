//Testbench for N-Bit Serial In Parallel Out Shift Register
`timescale 1ns/1ps
module sipo_nbit_tb();
  //1. Signal declaration
  localparam N=4;
  reg clk, reset;
  reg d;
  reg [(N-1):0] serial_data;
  wire [(N-1):0] q;
  integer i;
  //2. DUT instantiation
  sipo_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.d(d),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("sipo_nbit_tb.vcd");
    $dumpvars(0,sipo_nbit_tb);
    //4.2 Dispaly
    $display(" Time | D Rst | Q");
    $display("------|-------|---");
    //4.3 Stimulus
    serial_data = 'b1011;
    d=0;reset=1; #12; //reset high
    reset=0; #10; //reset low
    for (i=N-1;i>=0;i=i-1) begin
      d = serial_data[i]; #10; //i=3,2,1,0 MSB first
    end
    reset=1; #10;     //reset high
    d=0;reset=0; #10; //reset low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,d,reset,q);
  end
endmodule
