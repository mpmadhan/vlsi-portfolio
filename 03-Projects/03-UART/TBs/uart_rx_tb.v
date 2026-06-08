//Testbench for UART Receiver Module
`timescale 1ns/1ns
module uart_rx_tb();
  //1. Signal declaration
  reg clk;
  reg reset;
  reg rx;
  wire rx_en;            //Declared wire here as we generated rx_en signal in TB
  wire [7:0] data_out;
  wire ready;
  //2. DUT instantiation
  uart_rx dut(.clk(clk),.reset(reset),.rx(rx),.rx_en(rx_en),.data_out(data_out),.ready(ready));
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  //4. RX_EN signal generation
  reg [8:0] rx_counter;                        //Tick for every 325 clock cycles
  always @(posedge clk or posedge reset) begin
    if(reset) rx_counter <= 0;
    else if(rx_counter == 324) rx_counter <= 0;
    else rx_counter <= rx_counter + 1'b1;
  end
  assign rx_en = (rx_counter == 324);
  
  //5. Tasks
  //5.1 Task to Start and Send and Stop the data
  task send_data(input [7:0] val);
    integer i;
    begin 
      $display("Sending data: %h",val);
      //Start bit
      rx = 1'b0; 
      repeat(16) @(posedge rx_en);    //Waiting for 16 rx_en ticks
      //DATA bits
      for(i=0;i<8;i=i+1) begin        //Sending byte serially through RX
        rx = val[i];
        repeat(16) @(posedge rx_en);  //Waiting for 16 rx_en ticks
      end
      //Stop bit
      rx = 1'b1;
      repeat(16) @(posedge rx_en);
    end
  endtask

  //5.2 Task to wait until Reception Completion
  task wait_rx();
  begin
    @(posedge ready);
  end
endtask

  //5.3 Check Data
  task check_data(input [7:0] val);
    begin
      if(data_out == val)
        $display("[PASS] SUCCESS! Verified Data: %h",data_out);
      else
        $display("[FAIL] Expected: %h; Received: %h at time %4t",val,data_out,$time);
    end
  endtask
        
  //6.Waveform and Stimulus
  initial begin
    //6.1 Waveform
    $dumpfile("uart_rx_tb.vcd");
    $dumpvars(0,uart_rx_tb);
    //6.2 Stimulus
    reset = 1'b1; rx = 1'b1;
    #12; reset = 1'b0;
    $display("---Sending DATA---");
    fork						          //Using fork join as send_data task will return 'ready' output which wait_rx task is waiting for.
      send_data(8'hAB);
      wait_rx();
    join
    $display("---DATA SENT---");
    $display("---Verifying DATA---");
    check_data(8'hAB);
    $finish;
  end
endmodule
