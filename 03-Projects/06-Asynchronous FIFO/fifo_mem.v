//FIFO Memory
module fifo_mem #(
  parameter DEPTH = 8,
  parameter DATA_LEN = 8,
  parameter WIDTH = 3
)(
  input wclk,
  input w_en,
  input [WIDTH:0] b_wptr,
  input [WIDTH:0] b_rptr,
  input [DATA_LEN-1:0] data_in,
  output [DATA_LEN-1:0] data_out,
  input full
);
  //Memory
  reg [DATA_LEN-1:0] fifo [0:DEPTH-1];
  
  always @(posedge wclk) begin
    if(w_en & ~full) begin
      fifo[b_wptr[WIDTH-1:0]] <= data_in; 
      //WIDTH-1 because the MSB bit is for checking wrap around we don't need it to write data into fifo
    end
  end
  assign data_out = fifo[b_rptr[WIDTH-1:0]];
endmodule
