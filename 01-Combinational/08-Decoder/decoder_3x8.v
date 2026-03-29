//RTL Code for 3x8 Decoder
module decoder_3x8(
  input [2:0] in,
  output reg [7:0] out
);
  always @(*) begin
    case (in)
      3'd0: out=8'b00000001; //8'd1;
      3'd1: out=8'b00000010; //8'd2;
      3'd2: out=8'b00000100; //8'd4;
      3'd3: out=8'b00001000; //8'd8;
      3'd4: out=8'b00010000; //8'd16;
      3'd5: out=8'b00100000; //8'd32;
      3'd6: out=8'b01000000; //8'd64;
      3'd7: out=8'b10000000; //8'd128;
      default : out=8'bx;
    endcase
  end
endmodule
      
