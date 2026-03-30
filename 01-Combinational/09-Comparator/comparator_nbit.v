//RTL Code for N-bit Comparator
module comparator_nbit #(parameter N=4)(
  input [(N-1):0] a,b,
  output eq,gt,lt
);
  assign eq = (a == b);
  assign gt = (a > b);
  assign lt = (a < b);
endmodule
