//RTL Code for N-Bit Parity Generator Circuit
module parity_generator_nbit #(parameter N=4)(
  input [(N-1):0] d,
  output parity
);
  //Generating Parity Bit (Output 0 if even no. of 1's)
  assign parity = (^d); //^d xors all bits in d
endmodule
