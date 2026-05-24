//UART Transmitter Module
module uart_tx(
  input clk, reset, tx_start, tx_en,
  //tx_start is the signal given by user to start trasmit, 
  //tx_en is the signal received from the baud_rate_generator module
  input [7:0] data_in,
  output reg tx, busy
);
  //State encoding
  localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam DATA = 2'b10;
  localparam STOP = 2'b11;
  //Registers
  reg [1:0] state, next_state;
  reg [7:0] data_reg;
  reg [2:0] bit_count; //counts 8 bits for DATA
  //Sequential block
  always @(posedge clk) begin
    if(reset) begin
      state <= IDLE;
      data_reg <= 0;
      bit_count <= 0;
    end
    else begin
      state <= next_state;
      if(state == IDLE && tx_start)
        data_reg <= data_in;
      if(state == DATA && tx_en) begin
        data_reg <= {1'b0,data_reg[7:1]};
        bit_count <= bit_count + 1'b1;
      end
      if(state == STOP)
        bit_count <= 0;
    end
  end
  //Combinational Next state logic block
  always @(*) begin
    case(state)
      IDLE: next_state = tx_start ? START : IDLE;
      START: next_state = tx_en ? DATA : START;
      DATA: next_state = (tx_en && bit_count == 7) ? STOP : DATA; 
      STOP: next_state = tx_en ? IDLE : STOP;
      default: next_state = IDLE;
    endcase
  end
  //Combinational Output logic
  always @(*) begin
    case(state)
      IDLE: begin
        busy = 1'b0;
        tx = 1'b1;
      end
      START: begin
        busy = 1'b1;
        tx = 1'b0;
      end
      DATA: begin
        busy = 1'b1;
        tx = data_reg[0];
      end
      STOP: begin
        busy = 1'b1;
        tx = 1'b1;
      end
      default: begin tx=1'b1; busy=1'b0; end
    endcase
  end
endmodule
