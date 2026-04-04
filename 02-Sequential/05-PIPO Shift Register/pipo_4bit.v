//RTL Code for 4-Bit Parallel In Parallel Out Shift Register
module pipo_4bit(
  input clk, reset,
  input [3:0] d,
  output reg [3:0] q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else
      q<=d;
  end
endmodule
