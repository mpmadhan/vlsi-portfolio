//UART Receiver Module
module uart_rx(
  input clk, reset, rx, rx_en,
  //rx_en is received from baud_rate_generator module 
  //rx is the transmitted signal from the transmitter
  output reg ready,
  output reg [7:0] data_out
);
  //State Encoding
  localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam DATA = 2'b10;
  localparam STOP = 2'b11;
  //Registers
  reg [1:0] state, next_state;
  reg [3:0] bit_count;
  reg [2:0] sample_count;
  reg [7:0] temp_reg;
  //Sequential logic
  always @(posedge clk) begin
    if(reset)
  end
  //Combinational Next state logic
  always @(*) begin
    case(state)
      IDLE: next_state = (rx == 0) ? START : IDLE;
      START: next_state = (rx_en) ? DATA : START;
      DATA: next_state = (rx_en && bit_count == 128) ? STOP : DATA;
      STOP: next_state = (rx_en) ? IDLE : STOP;
      default: next_state = IDLE;
    endcase
  end
  //Combinational Output logic
  always @(*) begin
    case(state)
      IDLE: ready = 1'b1;
      START: ready = 1'b0;
      DATA: ready = 1'b0;
      STOP: ready = 1'b0;
    endcase
  end
endmodule
