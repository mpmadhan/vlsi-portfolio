//Testbench for Traffic Light Controller Moore FSM
// RED (5 cycles) -> GREEN (5 cycles) -> YELLOW (2 cycles) 
`timescale 1ns/1ns
module traffic_signal_fsm_tb();
  //1. Signal Declaration
  reg clk,reset;
  wire red,green,yellow;
  //2. DUT instantiation
  traffic_signal_fsm dut(.clk(clk),.reset(reset),.red(red),.green(green),.yellow(yellow));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform +Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("traffic_signal_fsm_tb.vcd");
    $dumpvars(0,traffic_signal_fsm_tb);
    //4.2 Display
    $display(" Time | Rst | R G Y ");
    $display("------|-----|-------");
    //4.3 Stimulus
    reset=1; @(posedge clk);
    reset=0; @(posedge clk);
    repeat(8)
      @(posedge clk); //for 8 cycles
    reset=1; @(posedge clk);
    reset=0; @(posedge clk);
    repeat(15)
      @(posedge clk); //for 15 cycles
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b | %b %b %b ",$time,reset,red,green,yellow);
  end
endmodule
