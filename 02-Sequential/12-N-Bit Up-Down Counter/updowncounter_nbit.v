//RTL Code for N-Bit UP-DOWN Counter
//Dir 1 = DOWN Count, Dir 0 = UP Count
module updowncounter_nbit #(parameter N=4)(
  input clk, reset, enable, dir,
  output reg [(N-1):0] q
);
  always @(posedge clk) begin
    if(reset)
      q<=0;
    else if(enable) begin
      if(dir)
        q <= q-1;
      else
        q <= q+1;
    end
    else
      q<=q; //q holds if enable and reset is low
  end
endmodule
