//Self Checking Testbench for Synchronous FIFO
`timescale 1ns/1ns
module fifo_sync_tb();
  //1. Signal intergration
  localparam WIDTH = 8;
  localparam DEPTH = 16;
  reg clk;
  reg reset;
  reg read_en;
  reg [(WIDTH-1):0] data_in;
  reg write_en;
  wire empty;
  wire full;
  wire [(WIDTH-1):0] data_out;
  //2. DUT instantiation
  fifo_sync #(.WIDTH(WIDTH),.DEPTH(DEPTH)) dut(.clk(clk),.reset(reset),.read_en(read_en),
                                               .data_in(data_in),.write_en(write_en),
                                               .empty(empty),.full(full),.data_out(data_out));
  //3. Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  //4. Tasks
  //Task to write data into FIFO
  task write_data(input[(WIDTH-1):0] val);
    begin
      @(posedge clk);
      write_en <= 1'b1;
      data_in <= val;
      @(posedge clk);
      write_en <= 1'b0;
    end
  endtask

  //Task to read data and verify whether it match the expectation
  task read_check_data(input [(WIDTH-1):0] expected_val);
    begin
      @(posedge clk);
      read_en <= 1'b1;
      @(posedge clk);
      read_en <= 1'b0;
      @(posedge clk);
      if(data_out != expected_val)
        $display("[FAIL] Data mismatch! Expected: %h, Got: %h at time %t, FULL: %h, EMPTY: %h",expected_val,data_out,$time,full,empty);
      else
        $display("[PASS] Success! Verified data: %h, FULL: %h, EMPTY: %h",data_out,full,empty);
    end
  endtask
  
  //5. Waveform and Stimulus
  integer i;
  initial begin
    //Waveform
    $dumpfile("fifo_sync_tb.vcd");
    $dumpvars(0,fifo_sync_tb);
    //Stimulus
    reset=1; 
    read_en=0; 
    write_en=0; 
    data_in=0;
    repeat(2) @(posedge clk);     //Holding reset for 2 clock cycles
    reset=0;
    //Write operation
    $display("---Starting Write Operations---");
    write_data(8'hAB);
    write_data(8'hCD);
    write_data(8'hEF);
    
    //Read operation
    $display("---Starting Read Operation---");
    read_check_data(8'hAB);
    read_check_data(8'hCD);
    read_check_data(8'hEF);
    
    reset = 1'b1;
    repeat(2) @(posedge clk);
    reset = 1'b0;
    
    //Full flag testing
    $display("---Testing Full & Empty Condition---");
    for(i=0;i<DEPTH;i=i+1)
      write_data(i);
    @(posedge clk);
    if(full == 1'b1)
      $display("[PASS] FULL Flag Active, FIFO is FULL.");
    else
      $display("[FAIL] FULL Flag NOT Active but FIFO is FULL.");
    #20;
    //Empty flag testing
    for(i=0;i<DEPTH;i=i+1)
      read_check_data(i);
    @(posedge clk);
    if(empty == 1'b1)
      $display("[PASS] EMPTY Flag Active, FIFO is EMPTY.");
    else
      $display("[FAIL] EMPTY Flag NOT Active but FIFO is EMPTY.");
    #20;
    $finish;
  end
endmodule
