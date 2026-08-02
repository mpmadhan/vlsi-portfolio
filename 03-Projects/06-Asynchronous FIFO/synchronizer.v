//RTL Code for 2-FF Synchronizer
module synchronizer #(parameter WIDTH = 3)(
  input clk,
  input reset_n,
  input [WIDTH:0] din,
  output reg [WIDTH:0] dout
);
  reg [WIDTH:0] q1;
  always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
      q1 <= 0;
      dout <= 0;
    end
    else begin
      q1 <= din;
      dout <= q1;
    end
  end
endmodule
