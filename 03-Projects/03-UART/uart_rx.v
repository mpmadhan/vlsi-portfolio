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
  reg [2:0] bit_count;
  reg [3:0] sample_count;
  reg [7:0] temp_reg;
  //Sequential logic
  always @(posedge clk) begin
    if(reset) begin
      state <= IDLE;
      bit_count <= 0;
      sample_count <= 0;
      temp_reg <= 0;
    end
    else begin
      state <= next_state;
      case(state)
        IDLE: begin
          sample_count <= 0;
          bit_count <= 0;
        end
        START: begin
          if(rx_en) begin
            if(sample_count == 7)
              sample_count <= 0;
            else 
              sample_count <= sample_count + 1'b1;
          end
        end
        DATA: begin
          if(rx_en) begin
            sample_count <= sample_count + 1'b1;
            if(sample_count == 7)
              temp_reg <= {rx,temp_reg[7:1]};
            if(sample_count == 15) begin
              bit_count <= bit_count + 1'b1;
              sample_count <= 0;
            end
          end
        end
        STOP: begin
          if(rx_en) begin
            sample_count <= sample_count + 1'b1;
            if(sample_count == 15) begin
              bit_count <= 0;
              sample_count <= 0;
            end
          end
        end
      endcase
    end
  end
  //Combinational next state logic
  always @(*) begin
    case(state)
      IDLE: next_state = (rx == 0) ? START : IDLE;
      START: begin
        if(rx_en && sample_count == 7)
          next_state = (rx == 0)? DATA : IDLE;
        else
          next_state = START;
      end
      DATA: next_state = (rx_en && bit_count ==7 && sample_count == 15) ? STOP : DATA;
      STOP: next_state = (rx_en && sample_count == 15) ? IDLE : STOP;
      default: next_state = IDLE;
    endcase
  end
  //Combinational output logic
  always @(*) begin
    data_out = temp_reg;
    ready = 1'b0;
    case(state)
      STOP: begin ready = 1'b1; end
      default: begin ready = 1'b0; end
    endcase
  end
endmodule
