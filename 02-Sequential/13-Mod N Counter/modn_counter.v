//RTL Code for Mod-N Counter
module modn_counter #(
  parameter N=4,
  parameter M=10)(
  input clk, reset, enable,
  output [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else if(enable) begin
      if(q=(M-1))
        q<=0;
      else
        q<=q+1;
    end
    else
      q<=q;
  end
endmodule
