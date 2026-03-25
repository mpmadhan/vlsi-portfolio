//RTL Code for 2x1 Multiplexor
module mux_2x1(
  input a,
  input b,
  input sel,
  output y
);
  //assign y = sel ? b:a; //using ternary operator
  assign y = (~sel & a) | (sel & b); //using gate level logic
endmodule
