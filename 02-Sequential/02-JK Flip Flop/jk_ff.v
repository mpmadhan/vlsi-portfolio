//RTL Code for JK Flip Flop
/*
J K | Q 
0 0 | Q
0 1 | 0
1 0 | 1
1 1 | Q'

J K Q | Qnext
------|------
0 0 0 |   0
0 0 1 |   1
0 1 0 |   0
0 1 1 |   0
1 0 0 |   1
1 0 1 |   1
1 1 0 |   1
1 1 1 |   0
Qnext = (J'K'Q)|(JK'Q')|(JK'Q)|(JKQ')
      = K'Q(J|J') | JQ'(K'|K)
      = J.Q' | K'.Q
*/
module jk_ff(
  input clk, j, k, reset,
  output reg q
);
  always @(posedge clk) begin
    if(reset)
      q <= 0;
    else
      q <= (j&(~q))|((~k)&q);
  end
endmodule
