//RTL Code for SRAM
module sram(
  input clk,
  input reset_n,
  input cs,
  input w_en,
  input o_en,
  input [7:0] addr,
  inout [7:0] data,
  output reg ready
);
  //State Encoding
  parameter IDLE = 2'b00;
  parameter WRITE = 2'b01;
  parameter READ = 2'b10;
  parameter DONE = 2'b11;
  
  //Memory Creation
  reg [7:0] mem [0:255]; 
  
  //Registers
  reg [1:0] state, next_state;
  reg [7:0] data_out;
  reg r_en;
  
  //Reset Logic
  always @(posedge clk or negedge reset_n) begin
    if(!reset_n) 
      state <= IDLE;
    else
      state <= next_state;
  end
  
  //Output Logic
  always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
      data_out <= 0;
      ready <= 0;
      r_en <= 0;
    end 
    else begin
      case(state) 
        IDLE: begin
          r_en <= 0;
          ready <= 0;
        end
        WRITE: begin
          mem[addr] <= data;
          ready <= 0;
          r_en <= 0;
        end
        READ: begin
          data_out <= mem[addr];
          ready <= 0;
          r_en <= 0;
        end
        DONE: begin
          ready <= 1;
          r_en <= 1;
        end 
      endcase
    end
  end
  
  //Next State Logic
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if(cs && w_en) 
          next_state = WRITE;
        else if(cs && ~w_en && o_en)
          next_state = READ;
        else
          next_state = IDLE;
      end
      WRITE: next_state = DONE;
      READ: next_state = DONE;
      DONE: next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end
  //Assigning Read data from memory
  assign data = (r_en) ? data_out:8'bz;
endmodule
