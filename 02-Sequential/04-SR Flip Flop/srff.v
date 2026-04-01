//RTL Code for SR Flip Flop
/*
S R Q | Qnext
------|------
0 0 0 |   0
0 0 1 |   1
0 1 0 |   0
0 1 1 |   0
1 0 0 |   1
1 0 1 |   1
1 1 0 |   X
1 1 1 |   X
Qnext = S | (R'.Q)
*/
module srff(
  input clk, s, r, reset,
  output q
);
  always @(posedge clk) begin
    if(reset)
      q <= 0;
    else if(s&r)
      q <= 1'bx;
    else
      q <= s|((~r)&q);
  end
endmodule
