//RTL Code for N-Bit UP- Counter
module upcounter_nbit #(parameter N=4)(
  input clk, reset, enable,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else if(enable)
      q <= q+1;
    //if reset and enable is 0, count holds
  end
endmodule
