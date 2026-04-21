//Testbench for N-Bit Johnson Counter
`timescale 1ns/1ns
module johnsoncounter_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk,reset;
  wire [(N-1):0] q;
  //2. DUT instantiation
  johnsoncounter_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.q(q));
  //3. Clock Generation
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  //4. Waveform and Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("johnsoncounter_nbit_tb.vcd");
    $dumpvars(0,johnsoncounter_nbit_tb);
    //4.2 Display
    $display(" Time | Rst |  Q ");
    $display("------|-----|-----");
    //4.3 Stimulus
    reset=1; #12;//initial values
    reset=0;
    repeat(N-2)  //for checking reset behaviour
      @(posedge clk);
    reset=1; #20;
    reset=0;
    repeat(N+2)  //repeating for N+2 clock cycles
      @(posedge clk);
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b | %b ",$time,reset,q);
  end
endmodule
