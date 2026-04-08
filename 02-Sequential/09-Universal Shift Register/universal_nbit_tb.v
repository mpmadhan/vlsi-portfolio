//Testbench for N-Bit Universal Shift Register
//Sel: 0: Hold, 1: Shift Right, 2: Shift Left, 3: Load
`timescale 1ns/1ps
module universal_nbit_tb();
  //1. Signal declaration
  localparam N = 4;
  reg clk, reset;
  reg [1:0] sel;
  reg [(N-1):0] d;
  reg enable, left_in, right_in;
  wire [(N-1):0] q;
  //2. DUT instantiation
  universal_nbit #(.N(N)) dut(.clk(clk),
                              .reset(reset),
                              .sel(sel),
                              .d(d),
                              .enable(enable),
                              .left_in(left_in),
                              .right_in(right_in),
                              .q(q));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("universal_nbit_tb.vcd");
    $dumpvars(0,universal_nbit_tb);
    //4.2 Display
    $display(" Time | Rst Sel   D    En Left Right | Q ");
    $display("------|------------------------------|---");
    //4.3 Stimulus
    sel=2'b00;d='b1011;enable=0;left_in=0;right_in=0;reset=1; #10; //initial values
    reset=0; enable=1;
    sel=2'b11; #13;               //Loading input into Shift_reg
    sel=2'b01; //Right Shift, Reset low and Enable High
    repeat(N) begin
      #10;
    end
    sel=2'b10;
    repeat(N) begin
      #10;
    end
    d='b0110;sel=2'b11;left_in=1;right_in=1; #10;
    sel=2'b01;
    repeat(N) begin
      #10;
    end
    sel=2'b10;
    repeat(N) begin
      #10;
    end
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b %b %b %b | %b",$time,reset,d,enable,left_in,right_in,q);
  end
endmodule
