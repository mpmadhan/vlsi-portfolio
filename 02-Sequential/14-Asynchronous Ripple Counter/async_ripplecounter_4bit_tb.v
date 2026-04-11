//Testbench for 4-Bit Asynchronous Ripple Counter
`timescale 1ns/1ns
module async_ripplecounter_4bit_tb();
  //1. Signal declaration
  localparam N=4;
  reg clk,reset;
  wire [(N-1):0] q;
  //2. DUT instantiation
  async_ripplecounter_4bit #(.N(N)) dut(.clk(clk),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  //4. Waveform +Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("async_ripplecounter_4bit_tb.vcd");
    $dumpvars(0,async_ripplecounter_4bit_tb);
    //4.2 Display
    $display("Time | Rst Q");
    $display("-----|------");
    //4.3 Stimulus
    reset=1; @(posedge clk);    //Reset high
    reset=0;                    //Reset low
    repeat(1<<N)                //For 2^N clock cycles
      @(posedge clk);
    #100; @(posedge clk);		//delay
    reset=1; @(posedge clk);    //Reset high
    reset=0; @(posedge clk);    //Reset low
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b",$time,reset,q);
  end
endmodule
