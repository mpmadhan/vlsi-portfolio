//RTL Code for N-Bit Serial In Parallel Out Shift Register
module sipo_nbit #(parameter N=4)(
  input clk, reset,
  input d,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else
      q<={q[(N-2):0],d}; //Left shift
    //q<={d,q[(N-1):1]}; //Right Shift
  end
endmodule
