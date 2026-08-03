//RTL Code for Read Pointer Handle
module rptr_handle #(parameter WIDTH = 3)(
  input rclk,
  input r_en,
  input rreset_n,
  input [WIDTH:0] g_wptr_sync,
  output reg [WIDTH:0] b_rptr,
  output reg [WIDTH:0] g_rptr,
  output reg empty
);
  //Registers
  reg [WIDTH:0] b_rptr_next;
  reg [WIDTH:0] g_rptr_next;

  assign b_rptr_next = b_rptr + (~empty & r_en);
  assign g_rptr_next = (b_rptr_next >> 1) ^ b_rptr_next;
  
  always @(posedge rclk or negedge rreset_n) begin
    if(!rreset_n) begin
      b_rptr <= 0;
      g_rptr <= 0;
      empty <= 1;
    end
    else begin
      b_rptr <= b_rptr_next;
      g_rptr <= g_rptr_next;
      empty <= (g_rptr_next == g_wptr_sync);
    end
  end
endmodule
