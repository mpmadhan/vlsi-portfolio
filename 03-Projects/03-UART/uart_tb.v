//Testbench for UART Top module
`timescale 1ns/1ns
module uart_tb();
  //1. Sginal Declaration
  reg clk, reset, tx_start, rx;
  reg [7:0] data_in;
  wire tx, busy, ready;
  wire [7:0] data_out;
  //2. DUT instantiation
  uart_top dut(.clk(clk),.reset(reset),.tx_start(tx_start),.rx(1'b1),.data_in(data_in),.tx(tx),.busy(busy),.ready(ready),.data_out(data_out));
  //rx assigned 1'b1 as in uart_top module we have connected tx_internal with rx.
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("uart_tb.vcd");
    $dumpvars(0,uart_tb);
    //4.2 Display
    $display("| Time | TX_START | DATA_IN | RX | TX | BUSY | READY | DATA_OUT |");
    $display("|=-----|----------|---------|----|----|------|-------|----------|");
    //4.3 Stimulus
    reset = 1'b1; data_in = 0; tx_start = 0;
    @(posedge clk) reset = 0;
    @(posedge clk) data_in = 8'h4;
    @(posedge clk) tx_start = 1'b1;  //asserting after input
    @(posedge clk) tx_start = 0;     //deassert after assert
    repeat(50000) 
      @(posedge clk);
    @(posedge clk) reset = 1;
    @(posedge clk) reset = 0;
    @(posedge clk) data_in = 8'h7;
    @(posedge clk) tx_start = 1'b1;  //asserting after changing input
    @(posedge clk) tx_start = 0;     //deassert after assert
    //9600 Baud rate, 50MHz clock cycle => 5208 cycles per bit.
    //for a 10 bits approx 52080 cycles is required.
    repeat(100000)            
      @(posedge clk);
    if(data_out == 8'h7)
      $display("PASS: Data Received Correctly !");
    else
      $display("FAIL: Expected %h, got %h",data_in,data_out);
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("| %4t | %b | %h | %b | %b | %b | %b | %h |",$time,tx_start,data_in,rx,tx,busy,ready,data_out);
  end
endmodule
