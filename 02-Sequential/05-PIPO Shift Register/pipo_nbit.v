//RTL Code for N-Bit PIPO Shift Register
module pipo_nbit #(parameter N=4)(
  input clk, reset,
  input [(N-1):0] d;
  output reg [(N-1):0] q;
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else
      q<=d;
  end
endmodule
