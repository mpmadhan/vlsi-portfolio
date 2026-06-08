//Testbench for UART Transmitter Module
`timescale 1ns/1ns
module uart_tx_tb();
  //1. Signal declaration
  reg clk;
  reg reset;
  reg [7:0] data_in;
  wire tx_en;            //Declared wire here as we generated tx_en signal in TB
  reg tx_start = 1'b1;
  wire tx;
  wire busy;
  //2. DUT instantiation
  uart_tx dut(.clk(clk),.reset(reset),.data_in(data_in),.tx_en(tx_en),.tx_start(tx_start),.tx(tx),.busy(busy));
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  //4. TX_EN signal generation
  reg [12:0] tx_counter;
  always @(posedge clk or posedge reset) begin
  if(reset) tx_counter <= 0;
  else if(tx_counter == 5207) tx_counter <= 0;
  else tx_counter <= tx_counter + 1'b1;
  end
  assign tx_en = (tx_counter == 5207);
  
  //5. Tasks
  //5.1 Task to start the Transmission
  task start_tx();
    begin
      @(posedge clk);
      tx_start = 1'b0;
      @(posedge clk);
    end
  endtask

  //5.2 Task to send the user data
  task send_data(input [7:0] val);
    begin
      @(posedge clk);
      data_in = val;
      @(posedge clk);
      start_tx();
    end
  endtask

  //5.3 Task to wait until Tranmission Completion
  task wait_tx();
    begin
      @(negedge busy);
    end
  endtask

  //6.Waveform and Stimulus
  initial begin
    //6.1 Waveform
    $dumpfile("uart_tx_tb.vcd");
    $dumpvars(0,uart_tx_tb);
    //6.2 Display
    $display("Time | TX | Busy | TX_Start | DATA_in");
    $display("-----|----|------|----------|--------");
    //6.3 Stimulus
    reset = 1'b1; tx_start = 1'b1;
    #12; reset = 1'b0;
    $display("---Sending DATA---");
    send_data(8'hAB);
    wait_tx();
    $display("---DATA SENT---");
    $finish;
  end
  
  //7. Observation
  initial begin
    $monitor("%4t | %b | %b | %b | %h",$time, tx, busy, tx_start, data_in);
  end
endmodule
