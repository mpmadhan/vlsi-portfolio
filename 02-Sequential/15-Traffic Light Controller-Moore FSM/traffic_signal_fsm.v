//RTL Code ofr Traffic Light Controller Moore FSM
//RED (5 Cycles) -> GREEN (5 Cycles) -> YELLOW (2 Cycles) -> RED (5 Cycles)
module traffic_signal_fsm(
  //1. Ports
  input clk,reset,
  output reg red,yellow,green
);
  //2. State Encoding
  parameter RED = 2'b00;
  parameter GREEN = 2'b01;
  parameter YELLOW = 2'b10;
  //3. State Register (Sequential block)
  reg[1:0] state, next_state;
  always @(posedge clk) begin
    if(reset)
      state <= RED;
    else
      state <= next_state;
  end
