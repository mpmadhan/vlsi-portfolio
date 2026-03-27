//RTL Code for 8x3 Encoder
/*
I7 I6 I5 I4 I3 I2 I1 I0 | Y2 Y1 Y0
0  0  0  0  0  0  0  1  | 0  0  0
0  0  0  0  0  0  1  0  | 0  0  1
0  0  0  0  0  1  0  0  | 0  1  0
0  0  0  0  1  0  0  0  | 0  1  1
0  0  0  1  0  0  0  0  | 1  0  0
0  0  1  0  0  0  0  0  | 1  0  1
0  1  0  0  0  0  0  0  | 1  1  0
1  0  0  0  0  0  0  0  | 1  1  1
*/
module encoder_8x3(
  input [7:0] in,
  output [2:0] out
);
  assign out[2] = (I7 | I6 | I5 | I4);
  assign out[1] = (I2 | I3 | I6 | I7);
  assign out[0] = (I1 | I3 | I5 | I7);
endmodule
