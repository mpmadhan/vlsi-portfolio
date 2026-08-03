//RTL Code for Write pointer handle
module wptr_handle #(parameter WIDTH = 3)(
  input wclk,
  input wreset_n,
  input w_en,
  input [WIDTH:0] g_rptr_sync,
  output reg [WIDTH:0] b_wptr,
  output reg [WIDTH:0] g_wptr,
  output reg full
);
  //Extra registers
  reg [WIDTH:0] b_wptr_next;
  reg [WIDTH:0] g_wptr_next;
  reg wfull;

  assign b_wptr_next = b_wptr + (~full & w_en);
  assign g_wptr_next = (b_wptr_next >> 1) ^ b_wptr_next;
  
  always @(posedge wclk or negedge wreset_n) begin
    if(!wreset_n) begin
      b_wptr <= 0;
      g_wptr <= 0;
      full <= 0;
    end
    else begin
      b_wptr <= b_wptr_next;
      g_wptr <= g_wptr_next;
      full <= (g_wptr_next == {~g_rptr_sync[WIDTH:WIDTH-1],g_rptr_sync[WIDTH-2:0]});
    end
  end
endmodule
