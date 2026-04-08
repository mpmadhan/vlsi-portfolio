//RTL Code for Parallel IN Serial OUT Shift Register
module piso_nbit #(parameter N=4)(
  input clk, reset, load,
  input [(N-1):0] d,
  output q
);
  reg [(N-1):0] shift_reg;
  always @(posedge clk) begin
    if(reset)
      shift_reg <= 0;
    else if(load)
      shift_reg <= d;
    else
      shift_reg <= {shift_reg[(N-2):0],1'b0};
  end
  assign q = shift_reg[N-1];
endmodule
