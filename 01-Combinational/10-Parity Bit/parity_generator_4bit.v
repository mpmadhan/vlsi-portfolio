//RTL Code for 4-Bit Parity Generator Circuit
module parity_generator_4bit(
  input [3:0] d,
  output parity
);
  //Generating Parity Bit (Output 0 if even no. of 1's)
  assign parity = (d[3] ^ d[2] ^ d[1] ^ d[0]);
endmodule
