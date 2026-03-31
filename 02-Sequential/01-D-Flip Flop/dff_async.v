//RTL Code for Asynchronous D-Flip Flop
module dff_async(
  input clk,d,reset,
  output reg q
);
  always @(posedge clk | posedge reset) begin
    if(reset)
      q<=0;
    else
      q<=d;
  end
endmodule
