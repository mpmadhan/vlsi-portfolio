//Testbench for UART TOP Module
`timescale 1ns/1ns
module uart_tb();
  //1. Signal declaration
  reg clk;
  reg reset;
  reg tx_start = 1'b1;
  reg rx;
  reg [7:0] data_in;
  wire tx;
  wire busy;            //Declared wire here as we generated rx_en signal in TB
  wire ready;
  wire [7:0] data_out;
  //2. DUT instantiation
  uart_top dut(.clk(clk),.reset(reset),.tx_start(tx_start),.rx(rx),.data_in(data_in),.tx(tx),.busy(busy),.ready(ready),.data_out(data_out));
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  //4. Tasks
  //4.1 Task to Start and Send and Stop the data
  task send_data(input [7:0] val);
    begin
      @(posedge clk);
      data_in = val;
      @(posedge clk);
      tx_start = 1'b0;
      repeat(6000) @(posedge clk);
      tx_start = 1'b1;
      $display("---DATA SENT---");
    end
  endtask

  //5.3 Check Data
  task check_data(input [7:0] val);
    begin
      $display("---Verifying DATA---");
      @(posedge ready);
      if(data_out == val)
        $display("[PASS] SUCCESS! Verified Data: %h",data_out);
      else
        $display("[FAIL] Expected: %h; Received: %h at time %4t",val,data_out,$time);
    end
  endtask
        
  //6.Waveform and Stimulus
  initial begin
    //6.1 Waveform
    $dumpfile("uart_tb.vcd");
    $dumpvars(0,uart_tb);
    //6.2 Stimulus
    reset = 1'b1; rx = 1'b1;
    #12; reset = 1'b0;
    $display("---Sending DATA---");
    fork                   //Fork join, check_data checks for posedge ready while send_data is still transmitting
      send_data(8'hAB);
      check_data(8'hAB);
    join
    $finish;
  end
endmodule
