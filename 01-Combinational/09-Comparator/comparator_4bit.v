//RTL Code for 4-Bit Comparator
module comparator_4bit(
  input [3:0] a,b,
  output eq,gt,lt
);
  assign eq = (a==b);
  assign gt = (a > b);
  assign lt = (a < b);
endmodule
  
