//RTL Code for 4x2 Priority Encoder
/*
I3 I2 I1 I0 | Y1 Y0
0  0  0  1  | 0  0
0  0  1  X  | 0  1
0  1  X  X  | 1  0
1  X  X  X  | 1  1
*/
module priority_encoder_4x2(
  input [3:0] in,
  output [1:0] out
);
  always @(*) begin
    if(in[3])
      out[1:0]=1;
    else if(in[2])
      out[1]=1; out[0]=0;
    else if(in[1])
      out[1]=0; out[0]=1;
    else if(in[0])
      out[1:0]=0;
  end
endmodule
