//RTL Code for Synchronous D-Flip flop
module dff_sync(
  input clk, d, rst,
  output reg q
);
  always @(posedge clk) begin
    if(rst)
      q<=0;
    else
      q<=d;
  end
endmodule
