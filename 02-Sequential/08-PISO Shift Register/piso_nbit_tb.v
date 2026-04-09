//Testbench for Parallel IN Serial OUT Shift Register
`timescale 1ns/1ps
module piso_nbit_tb();
  //1. Signal declaration
  localparam N = 4;
  reg clk, reset, load;
  reg [(N-1):0] d;
  wire q;
  integer i;
  //2. DUT instantiation
  piso_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.load(load),.d(d),.q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("piso_nbit_tb.vcd");
    $dumpvars(0,piso_nbit_tb);
    //4.2 Display
    $display(" Time |   D   Rst | Q ");
    $display("------|-----------|---");
    //4.3 Stimulus
    d='b1011; load=0; reset=1; #13; //Reset High
    load=0; reset=0; #10;           //Reset Low
    load=1; #10;                    //Load High
    load=0;
    repeat(N) begin                 
      #10;
    end          
    d='b0110; load=1; #10;
    load=0;
    repeat(N) begin
      #10;
    end
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b",$time,d,reset,q);
  end
endmodule
