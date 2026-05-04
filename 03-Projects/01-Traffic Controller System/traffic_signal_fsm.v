
//RTL Code ofr Traffic Light Controller Moore FSM
//RED (5 Cycles) -> GREEN (5 Cycles) -> YELLOW (2 Cycles) -> RED (5 Cycles)
module traffic_signal_fsm(
  //1. Ports
  input clk,reset,
  output reg red,green,yellow
);
  //2. State Encoding
  parameter RED = 2'b00;
  parameter GREEN = 2'b01;
  parameter YELLOW = 2'b10;
  //3. Sequential block
  reg [1:0] state,next_state;
  always @(posedge clk) begin
    if(reset)
      state <= RED;
    else
      state <= next_state;
  end
  //4. Count block
  reg [2:0] count;
  reg counter_reset;
  always @(posedge clk) begin
    if(reset || counter_reset)
      count<=0;
    else
      count<=count+1;
  end
  //5. Combinational block
  always @(*) begin
    next_state = state;
    counter_reset = 0;
    case(state)
      RED: begin
        if(count == 4) begin
          next_state = GREEN;
          counter_reset = 1;
        end
      end
      GREEN: begin
        if(count == 4) begin
          next_state = YELLOW;
          counter_reset = 1;
        end
      end
      YELLOW: begin
        if(count == 1) begin
          next_state = RED;
          counter_reset = 1;
        end
      end
      default: next_state = RED;
    endcase
  end
  //6. Output
  always @(*) begin
    red = (state == RED);
    green = (state == GREEN);
    yellow = (state == YELLOW);
  end
endmodule
```
