//RTL Code for T-Flip Flop
/*
T Q | Qnext
0 0 |  0
0 1 |  1
1 0 |  1
0 1 |  0
Qnext = T^Q
*/
module tff(
  input clk, t, reset,
  output q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else
      q<=(t^q);
  end
endmodule
