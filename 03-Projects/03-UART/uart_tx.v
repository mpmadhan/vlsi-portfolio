//UART Transmitter Module
module uart_tx(
  input clk, reset,
  input tx_start, tx_en,
  input [7:0] data_in,
  output reg tx,
  output reg busy
);
//State encoding
  localparam TX_IDLE = 2'b00;
  localparam TX_START = 2'b01;
  localparam TX_DATA = 2'b10;
  localparam TX_STOP = 2'b11;
  //Registers
  reg [1:0] state;
  reg [2:0] bit_pos = 0;
  reg [7:0] temp_reg;
  //Sequential block
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      state <= TX_IDLE;
      bit_pos = 0;
      temp_reg <=0;
      tx <= 1'b1;
      busy <= 1'b0;
    end
    else begin
      case(state)
        TX_IDLE: begin
          tx <= 1'b1;
          busy <= 1'b0;
          if(~tx_start && tx_en) begin
            busy <= 1'b1;	
            temp_reg <= data_in;
            state <= TX_START;
          end
        end
        TX_START: begin
          tx <= 1'b0;
          state <= TX_DATA;
        end
        TX_DATA: begin
          busy <= 1'b1;
          if(tx_en) begin
            tx <= temp_reg[bit_pos];
            bit_pos <= bit_pos + 1'b1;
            if(bit_pos == 7) begin
              state <= TX_STOP;
              bit_pos <= 0;
            end
          end
        end
        TX_STOP: begin
          if(tx_en) begin
            state <= TX_IDLE;
            tx <= 1'b1;
            busy <= 1'b0;
          end
        end
        default: begin
          state <= TX_IDLE;
          tx = 1'b1;
          busy <= 1'b1;
        end
      endcase
    end
  end
endmodule
