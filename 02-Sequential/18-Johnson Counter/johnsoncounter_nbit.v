//RTL Code for N-Bit Johnson Counter
module johnsoncounter_nbit #(parameter N=4)(
  input clk,reset,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q <= 0;
    else
      q <= {~q[0],q[(N-1):1]};
  end
endmodule
