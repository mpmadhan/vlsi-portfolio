//RTL Code for Full Adder (2 inputs, 1 Cin)
module full_adder(
  input a, b, cin,
  output sum, cout
);
  assign sum = a^b^cin;
  assign cout = (a&b)|(b&cin)|(cin&a);
endmodule
