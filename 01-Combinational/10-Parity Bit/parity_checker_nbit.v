//RTL Code for N-bit Parity Checker
module parity_checker_nbit #(parameter N=4)(
  input [(N-1):0] d,
  input parity,
  output error
);
  assign error = ((^d)^parity); 
  //^d xor's all bits of d
  //if error = 1, then error in data
endmodule
