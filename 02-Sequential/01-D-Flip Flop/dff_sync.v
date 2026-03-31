//RTL Code for Synchronous D-Flip flop
module dff_sync(
  input clk, d, reset,
  output reg q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else
      q<=d;
  end
endmodule
