//RTL Code for Mealy Sequence detector - 1011
module mealy_1011_detector(
  //1. Ports
  input clk,reset,din,
  output reg q
);
  //2. State encoding
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;
  //3. Sequential Block
  reg [1:0] state,next_state;
  always @(posedge clk) begin
    if(reset)
      state <= S0;
    else
      state <= next_state;
  end
  //4. Combinational block
  always @(*) begin
    next_state = state;
    q=0;
    case(state)
      S0: begin
        if(din)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if(din)
          next_state = S1;
        else
          next_state = S2;
      end
      S2: begin
        if(din)
          next_state = S3;
        else
          next_state = S0;
      end
      S3: begin
        if(din) begin
          next_state = S1; //Overlapping
          //next_state = S0; //Non-Overlapping
          q=1;
        end
        else
          next_state = S2;
      end 
    endcase
  end
endmodule
