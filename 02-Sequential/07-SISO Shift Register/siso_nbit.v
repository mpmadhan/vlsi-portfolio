//RTL Code for N-Bit Serial IN Serial OUT Shift Register
module siso_nbit #(parameter N=4)(
  input clk, reset,
  input d,
  output q
);
  reg [(N-1):0] shift_reg;
  always @(posedge clk) begin
    if(reset)
      shift_reg <= 0;
    else
      shift_reg <= {shift_reg[(N-2):0],d}; //Right shift
    //shift_reg <= {d,shift_reg[(N-1):1]}  //Left Shift
  end
  assign q = shift_reg[N-1];
endmodule
