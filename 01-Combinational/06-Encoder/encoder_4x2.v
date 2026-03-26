/*RTL Code for 4x2 Encoder

I3 I2 I1 I0 | Y1 Y0
0  0  0  1  | 0  0
0  0  1  0  | 0  1
0  1  0  0  | 1  0
1  0  0  0  | 1  1
*/
module encoder_4x2(
  input [3:0] i,
  output [1:0] y
);
  assign y[1] = i[2] | i[3]; //Y1 is high when I2 and I3 are high
  assign y[0] = i[1] | i[3]; //Y0 is high when I1 and I3 are high
endmodule
