//RTL Code for UART Transmitter
module uart_tx #(
  parameter CLK_FREQ = 50000000,
  parameter BAUD_RATE = 9600
)( 
  input clk, reset, start,
  input [7:0] data_in,
  output reg tx,
  output reg busy
);
  localparam BAUD_DIV = CLK_FREQ/BAUD_RATE; //5208
  //State Encoding
  localparam IDLE  = 2'b00;
  localparam START = 2'b01;
  localparam DATA  = 2'b10;
  localparam STOP  = 2'b11;

  reg[1:0] next_state;
  reg[12:0] baud_cnt;
