//RTL Code for SYNCHRONOUS FIFO
module fifo_sync #(
  parameter WIDTH = 8,
  parameter DEPTH = 16                      //Depth should be power of 2
)(
  input clk,
  input reset,
  input read_en,
  input [(WIDTH-1):0] data_in,
  input write_en,
  output empty,
  output full,
  output reg [(WIDTH-1):0] data_out
);
  localparam ADDR_WIDTH = $clog2(DEPTH);    //$clog2 calculates the number of bits required to represent the value
  //Creating Memory
  reg [(WIDTH-1):0] memory [0:(DEPTH-1)];
  //Creating Pointers
  reg [(ADDR_WIDTH):0] read_ptr;            //not ADDR_WIDTH-1:0 as because we are using a extra bit to check overflow and full condition  
  reg [(ADDR_WIDTH):0] write_ptr;           //not ADDR_WIDTH-1:0 as because we are using a extra bit to check overflow and full condition
  //Sequential block
  always @(posedge clk) begin
    if(reset) begin
      write_ptr <= 0;
      read_ptr <= 0;
    end
    else begin 
      //Write
      if(write_en && ~full) begin           //Overflow protection logic ~full
        memory[write_ptr[(ADDR_WIDTH-1):0]] <= data_in;
        write_ptr <= write_ptr + 1'b1;
      end
      //Read
      if(read_en && ~empty) begin          //Underflow protection logic ~empty
        data_out <= memory[read_ptr[(ADDR_WIDTH-1):0]];
        read_ptr <= read_ptr + 1'b1;
      end 
    end
  end
  //Assigning Empty and Full Flags
  assign empty = (read_ptr == write_ptr);
  assign full = ((write_ptr[ADDR_WIDTH] != read_ptr[ADDR_WIDTH]) && 
                 (write_ptr[(ADDR_WIDTH-1):0]) == read_ptr[(ADDR_WIDTH-1):0]);
endmodule
