//RTL Code for Mod-N Counter
module modn_counter #(parameter N=10)(
  input clk, reset, enable,
  output [//(N-1):0]
);
