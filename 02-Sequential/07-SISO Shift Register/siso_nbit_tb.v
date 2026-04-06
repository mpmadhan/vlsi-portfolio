//Testbench for N-Bit Serial IN Serial OUT Shift Register
`timescale 1ns/1ps
module siso_nbit_tb();
  //1. Signal Declaration
  localparam N=4;
  reg clk, reset;
  reg d;
  reg [(N-1):0] shift_reg;
  wire q;
  //2. DUT instantiation
  siso_nbit #(.N(N)) dut(.clk(clk),.reset(reset),.d(d),.q(q));
  //3. Clock Generation
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  //4. Waveform + Stimulus
  initial begin
    //4.1 Waveform
    $dumpfile("siso_nbit_tb.vcd");
    $dumpvars(0,siso_nbit_tb);
    //4.2 Display
    $display(" Time | D Rst | Q ");
    $display("------|-------|---");
    //4.3 Stimulus
    serial_data = 1'b1011;
    reset=1;d='1; #12; //Reset High
    reset=0; #10;     //Reset low
    for(i=N-1;i=0;i=i-1) begin
      d=serial_data[i]; #10;         //Input High
    end
    repeat(N) begin
      d=0; #10;
    end
    $finish;
  end
  //5. Observation
  initial begin
    $monitor("%4t | %b %b | %b ",$time,d,reset,q);
  end
endmodule
