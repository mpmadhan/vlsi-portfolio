//Testbench for SRAM
`timescale 1ns/1ns
module sram_tb();
  //1. Signal Declaration
  reg clk;
  reg reset_n;
  reg cs;
  reg w_en;
  reg o_en;
  reg [7:0] addr;
  inout [7:0] data;
  wire ready;
  //2. DUT instantiation
  sram dut(.clk(clk),.reset_n(reset_n),.cs(cs),.w_en(w_en),.o_en(o_en),.addr(addr),.data(data),.ready(ready));
  //3. Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //4. Tasks
  //Task to write data
  task write_data(input [7:0] val, input [7:0] address);
    begin
      @(posedge clk);
      cs <= 1'b1;
      w_en <= 1'b1;
      data <= val;
      addr <= address;
      @(posedge clk);
      w_en <= 1'b0;
      cs <= 1'b0;
    end
  endtask
  
  //Task to Read and check Data
  task read_check_data(input [7:0] expect_val, input [7:0] address);
    begin
      
