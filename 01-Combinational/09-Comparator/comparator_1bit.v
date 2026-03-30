//RTL Code for 1-bit Comparator
/*
A B | A>B A=B A<B
0 0 |  0   1   0
0 1 |  0   0   1
1 0 |  1   0   0
1 1 |  0   1   0
*/
module comparator_1bit(
  input a,b,
  output eq,gt,lt
);
  assign eq = ~(a^b);
  assign gt = (a&(~b));
  assign lt = ((~a)&b);
endmodule
