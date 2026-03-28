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
  output reg [1:0] out,
  output reg valid
);
  always @(*) begin
    if(in[3]) begin
      out=2'b11;
      valid = 1;
    end
    else if(in[2]) begin
      out= 2'b10;
      valid = 1;
    end
    else if(in[1]) begin
      out=2'b01;
      valid =1;
    end
    else if(in[0]) begin
      out=2'b00;
      valid =1;
    end
    else begin
      out=2'bxx;
      valid =0;
    end
  end
endmodule
