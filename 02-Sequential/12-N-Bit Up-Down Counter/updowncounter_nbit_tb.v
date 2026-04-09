//Testbench for N-Bit UP-DOWN Counter
`timescale 1ns/1ps
module updowncounter_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk,reset,enable,dir;
  wire [(N-1):0] q;
  //2. DUT instantiation
  updowncounter_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.enable(enable),.dir(dir),.q(q));
  //3. Clock Generation
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  //4. Waveform and Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("updowncounter_nbit_tb.vcd");
    $dumpvars(0,updowncounter_nbit_tb);
    //4.2 Display
    $display(" Time | Dir   Q   En Rst");
    $display("------|-----------------");
    //4.3 Stimulus
    dir=0;reset=1;enable=0; #10; //Up Counter, Initial values 
    reset=0; #10;                //Reset Low
    enable=1; #10;               //Enable High
    repeat(N)
      @(posedge clk);
    dir=1; #30;                  //Down Counter
    reset=1; #10;                //Reset High
    reset=0; #10;                //Reset low
    repeat(N)
      @(posedge clk);
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b %b %b",$time,dir,q,enable,reset);
  end
endmodule
    
    
