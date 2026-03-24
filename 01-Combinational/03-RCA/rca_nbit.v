//RTL Code for N-Bit Ripple Carry Adder
module rca_nbit #(parameter WIDTH = 4)(
  input [(WIDTH-1):0] a,b,
  input cin,
  output [(WIDTH-1):0] sum,
  output cout
);
  assign {cout,sum} = a + b + cin;
endmodule
