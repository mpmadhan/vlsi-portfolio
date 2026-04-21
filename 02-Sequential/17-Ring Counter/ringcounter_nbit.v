//RTL Code for N-Bit Ring Counter
module ringcounter_nbit #(parameter N=4)(
  input clk,reset,
  output reg q
);
  always @(posedge clk) begin
    if(reset)
      q <= {{(N-1){1'b0}},1'b1};
    else
      q <= {q[0],q[(N-1):1]};
  end
endmodule
