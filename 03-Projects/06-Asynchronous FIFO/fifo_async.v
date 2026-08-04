//RTL Code for TOP Module of Asynchronous FIFO Module
module fifo_async #(
  parameter DEPTH = 8,
  parameter DATA_LEN = 8,
  parameter WIDTH = 3
)(
  //Write domain ports
  input wclk,
  input w_en,
  input wreset_n,
  input [DATA_LEN-1:0] data_in,
  output full,
  //Read domain ports
  input rclk,
  input r_en,
  input rreset_n,
  output [DATA_LEN-1:0] data_out,
  output empty
);
  //Registers
  reg [WIDTH:0] b_wptr, g_wptr;
  reg [WIDTH:0] b_rptr, g_rptr;
  reg [WIDTH:0] g_wptr_sync;
  reg [WIDTH:0] g_rptr_sync;
  //Instantiation
  wptr_handle #(.WIDTH(WIDTH)) dut1 (
    .wclk(wclk),
    .wreset_n(wreset_n),
    .w_en(w_en),
    .g_rptr_sync(g_rptr_sync),
    .b_wptr(b_wptr),
    .g_wptr(g_wptr),
    .full(full)
  );

  rptr_handle #(.WIDTH(WIDTH)) dut2(
    .rclk(rclk),
    .rreset_n(rreset_n),
    .r_en(r_en),
    .g_wptr_sync(g_wptr_sync),
    .b_rptr(b_rptr),
    .g_rptr(g_rptr),
    .empty(empty)
  );

  synchronizer #(.WIDTH(WIDTH)) dut3(
    .clk(wclk),
    .reset_n(wreset_n),
    .din(g_rptr),
    .dout(g_rptr_sync)
  );

  synchronizer #(.WIDTH(WIDTH)) dut4(
    .clk(rclk),
    .reset_n(rreset_n),
    .din(g_wptr),
    .dout(g_wptr_sync)
  );

  fifo_mem #(
    .DEPTH(DEPTH),
    .DATA_LEN(DATA_LEN),
    .WIDTH(WIDTH)
  ) dut5(
    .wclk(wclk),
    .w_en(w_en),
    .b_wptr(b_wptr),
    .b_rptr(b_rptr),
    .full(full),
    .data_in(data_in),
    .data_out(data_out)
  );
endmodule
