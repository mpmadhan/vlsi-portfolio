//UART Module that instantiates baud_rate_generator, uart_tx, uart_rx modules
module uart_top(
  input clk, reset, tx_start, rx, 
  input [7:0] data_in,
  output tx, busy, ready,
  output [7:0] data_out
);
  wire tx_en, rx_en;
  wire tx_internal;
  baud_rate_generator baud(.clk(clk),.reset(reset),.tx_en(tx_en),.rx_en(rx_en));
  uart_tx transmitter(.clk(clk),.reset(reset),.tx_start(tx_start),.tx_en(tx_en),.data_in(data_in),.tx(tx_internal),.busy(busy));
  uart_rx receiver(.clk(clk),.reset(reset),.rx(tx_internal),.rx_en(rx_en),.ready(ready),.data_out(data_out));
  assign tx = tx_internal;
endmodule
