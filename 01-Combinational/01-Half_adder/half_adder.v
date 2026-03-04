//RTL Code for Half Adder
module half_adder(
  input a,
  input b,
  output sum,
  output cout //Carry
);
  assign sum = a^b; 
  assign cout = a&b;
endmodule
