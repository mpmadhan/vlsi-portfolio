//RTL Code for 4-bit Parity Checker
module parity_checker_4bit(
  input [3:0] d,
  input parity,
  output error
);
  assign error = (d[3]^d[2]^d[1]^d[0]^parity);
  //if error = 1, then error in data
endmodule
