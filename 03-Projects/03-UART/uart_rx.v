//UART Receiver Module
module uart_rx(
  input clk, reset, rx, rx_en,
  //rx_en is received from baud_rate_generator module 
  //rx is the transmitted signal from the transmitter
  output reg ready,
  output reg [7:0] data_out
);
  //State Encoding
  localparam RX_START = 2'b01;
  localparam RX_DATA = 2'b10;
  localparam RX_STOP = 2'b11;
  //Registers
  reg [1:0] state;
  reg [2:0] bit_pos;
  reg [3:0] sample_count = 0;
  reg [7:0] temp_reg;
  //Sequential logic
  always @(posedge clk) begin
    if(reset) begin
      state <= RX_START;
      bit_pos <= 0;
      sample_count <= 0;
      temp_reg <= 0;
      ready <= 1'b1;
    end
    else begin
      ready <= 1'b0;
      case(state)
        RX_START: begin
          if(~rx) begin
            if(rx_en)
              sample_count <= sample_count + 1'b1;
            if(sample_count == 15) begin
              state <= RX_DATA;
              sample_count <= 0;
              bit_pos <= 0;
              temp_reg <= 0;
            end
          end
          else
            sample_count <= 0;
        end
        RX_DATA: begin
          if(rx_en) begin
            sample_count <= sample_count + 1'b1;
            if(sample_count == 7) begin
              temp_reg[bit_pos] <= rx;            //Sampling mid bit value for accuracy
            end
            if(sample_count == 15) begin
              sample_count <= 0;
              bit_pos <= bit_pos + 1'b1;
            end
            if(bit_pos == 7 && sample_count == 15) begin
              state <= RX_STOP;
            end
          end
        end
        RX_STOP: begin
          if(rx_en) begin
            data_out <= temp_reg;
            ready <= 1'b1;
            state <= RX_START;
          end
        end
      endcase
    end
  end
endmodule
