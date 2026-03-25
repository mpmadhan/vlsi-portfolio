//RTL Code for 1x4 DeMux
module demux_1x4(
  input in,
  input [1:0] sel,
  output reg y0,y1,y2,y3
);
  always @(*) begin
    case (sel)
      2'b00 : {y0,y1,y2,y3} = {in,3'b0};
      2'b01 : {y0,y1,y2,y3} = {1'b0,in,2'b0};
      2'b10 : {y0,y1,y2,y3} = {2'b0,in,1'b0};
      2'b11 : {y0,y1,y2,y3} = {3'b0,in};
    endcase
  end
endmodule
