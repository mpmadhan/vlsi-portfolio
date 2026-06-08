//Testbench for Baud Rate generator module
`timescale 1ns/1ns
module baud_rate_generator_tb();
  //1. Signal intergration
  localparam CLK_FREQ = 50000000;
  localparam BAUD_RATE = 9600;
  reg clk;
  reg reset;
  wire tx_en;
  wire rx_en;
  //2. DUT instantiation
  baud_rate_generator #(.CLK_FREQ(CLK_FREQ),.BAUD_RATE(BAUD_RATE)) dut(.clk(clk),.reset(reset),.tx_en(tx_en),.rx_en(rx_en));
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveofmr
    $dumpfile("baud_rate_generator_tb.vcd");
    $dumpvars(0,baud_rate_generator_tb);
    //4.2 Display
    $display("Time | Rst | TX_EN | RX_EN");
    $display("-----|-----|-------|------");
    //4.3 Stimulus
    reset = 1'b1;
    #12 reset = 1'b0;
    //approx takes 5208 clock cycles to get one tick tx_en and 325 clock cycles to get one tick rx_en
    repeat(50000) @(posedge clk);
    $finish;
  end
  //5. Observation
  initial begin
    $monitor(" %t | %b | %b | %b ",$time, reset, tx_en, rx_en);
  end
endmodule
