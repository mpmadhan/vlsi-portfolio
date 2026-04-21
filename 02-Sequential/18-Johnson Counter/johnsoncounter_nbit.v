//RTL Code for N-Bit Johnson Counter
module johnosoncounter_nbit #(parameter N=4)(
  input clk,reset,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q <= {{(N-1){1'b0}},1'b1};
    else
      q <= {~q[0],q[(N-1):1]};
  end
endmodule
