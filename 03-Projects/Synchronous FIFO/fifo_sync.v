//IN-PROGRESS
//RTL Code for Synchronous FIFO
module fifo_sync #(
  parameter WIDTH = 8,
  parameter DEPTH = 16 //Depth should be power of 2
)(
  input clk,
  input reset,
  input read_en,
  input [(WIDTH-1):0] data_in,
  input write_en,
  output empty,
  output full,
  output [(WIDTH-1):0] data_out
);
  localparam ADDR_WIDTH = $clog2(DEPTH);
  //memory creation
  reg [(WIDTH-1):0] memory [0:(DEPTH-1)];
  //pointers
  reg [(ADDR_WIDTH):0] read_ptr;            //not ADDR_WIDTH-1:0 as because we are using a extra bit to check overflow and full condition  
  reg [(ADDR_WIDTH):0] write_ptr;           //not ADDR_WIDTH-1:0 as because we are using a extra bit to check overflow and full condition
  //Sequential block
  always @(posedge clk) begin
    if(reset) begin
      write_en <= 0;
      read_en <= 0;
      empty <= 0;
      full <= 0;
    end
    else begin
      if(write_ptr == read_ptr) begin
        empty <= 1'b1;
        //IN-PROGRESS
  
