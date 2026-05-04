//RTL Code for designing N-Bit ALU
/*sel:0: A+B, 1: A-B, 2: A&B, 3: A|B, 4: A^B, 5: ~(A&B), 6: ~(A|B), 7: ~(A^B), 8: Left Shift
  sel:9: Right Shift, A. Rotate Left, B. Rotate Right, C.A>B, D. A==B, E. A+1, F. A-1. 
  default: A+B*/
module alu_nbit #(parameter N=4)(
  input [(N-1):0] a,b,
  input [3:0] sel,
  output reg [(N-1):0] result,
  output reg carry,zero
);
  always @(*) begin
    carry=0; //initial values
    zero=0;
    case(sel)
      4'h0: {carry,result} = a+b;          //Addition
      4'h1: {carry,result} = a-b;          //Subtraction
      4'h2: result = a&b;                  //Bitwise AND
      4'h3: result = a|b;                  //Bitwise OR
      4'h4: result = a^b;                  //Bitwise XOR
      4'h5: result = ~(a&b);               //Bitwise NAND
      4'h6: result = ~(a|b);               //Bitwise NOR
      4'h7: result = ~(a^b);               //Bitwise XNOR
      4'h8: result = (a<<1);               //Shift Left
      4'h9: result = (a>>1);               //Shift Right 
      4'ha: result = {a[(N-2):0],a[N-1]};  //Rotate Left
      4'hb: result = {a[0],a[(N-1):1]};    //Rotate Right
      4'hc: result = (a>b)?1:0;            //Greater than comparison check
      4'hd: result = (a==b)?1:0;           //Equal to comparison
      4'he: result = a+1'b1;               //Increment operator
      4'hf: result = a-1'b1;               //Decrement operator
      default: {carry,result} = a+b;
    endcase
    if(!result)
      zero=1'b1;
  end
endmodule
