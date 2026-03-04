//RTL Code that implements Full Adder using Half Adders
module fa_with_ha(
  input a, b, cin,
  output sum, cout
);
  wire sum1, carry1, carry2;
  half_adder ha1(.a(a), .b(b), .sum(sum1), .cout(carry1));
  half_adder ha2(.a(sum1), .b(cin), .sum(sum), .cout(carry2));
  assign cout = carry1 | carry2;
endmodule
