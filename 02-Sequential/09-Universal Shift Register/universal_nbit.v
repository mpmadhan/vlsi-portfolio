//RTL Code for N-Bit Universal Shift Register
//Universal shift register, 4 operations: 1.Hold, 2.Shift Right, 3.Shift Left, 4.Parallel load
module universal_nbit #(parameter N=4)(
  input clk, reset, load,
  input [1:0] sel,
  input enable, left_in, right_in,
  input [(N-1):0] d,
  output [(N-1):0] q
);
  reg [(N-1):0] shift_reg;
  always @(posedge clk) begin
    if(reset)
      shift_reg <= 0;
    else if(enable) begin
      case(sel)
        2'b01: shift_reg <= {right_in,shift_reg[(N-1):1]};
        2'b10: shift_reg <= {shift_reg[(N-2):0],left_in};
        2'b11: shift_reg <= d;
        default: shift_reg <= shift_reg;
      endcase
    end
  end
  assign q = shift_reg;
endmodule
