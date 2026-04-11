/*RTL Code for Asynchronous Ripple counter
We require Asynchronous T flip flop to code Asynchronous Ripple counter
Creating Async T Flip flop module first*/
module tff_async(
  input clk,reset,
  output reg q
);
  always @(posedge clk or posedge reset) begin
    if(reset)
      q<=0;
    else
      q<=~q;
  end
endmodule

//4-Bit Asynchronous Ripple Counter
module async_ripplecounter #(parameter N=4)(
  input clk,reset,
  output [(N-1):0] q
);
  tff_async ff0(.clk(clk),.reset(reset),.q(q[0]));
  tff_async ff1(.clk(q[0]),.reset(reset),.q(q[1]));
  tff_async ff2(.clk(q[1]),.reset(reset),.q(q[2]));
  tff_async ff3(.clk(q[2]),.reset(reset),.q(q[3]));
endmodule
