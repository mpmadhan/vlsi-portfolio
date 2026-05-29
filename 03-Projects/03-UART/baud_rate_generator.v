/*
Baud Rate Generator for UART
CLK_FREQ  : Input clock frequency (default: 50MHz)
BAUD_RATE : Desired baud rate (default: 9600)
tx_en : one pulse every (CLK_FREQ / BAUD_RATE) cycles
          = 50MHz / 9600 = ~5208 cycles per bit => one pulse every 5208 cycles
rx_en : one pulse every (CLK_FREQ / (BAUD_RATE * 16)) cycles
           = 50MHz / 153600 = ~325 cycles => one pulse every 325 cycles
16x oversampling for accurate sampling and receiving the transmitted data without any loss
*/

module baud_rate_generator #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    input  clk, reset,
    output tx_en, rx_en
);

    localparam TX_DIV = CLK_FREQ / BAUD_RATE;
    localparam RX_DIV = CLK_FREQ / (BAUD_RATE * 16);
    reg [$clog2(TX_DIV)-1 :0] tx_counter;
    reg [$clog2(RX_DIV)-1 :0] rx_counter;

    // TX counter: counts up to TX_DIV-1, then resets
    always @(posedge clk) begin
        if (reset)
            tx_counter <= 0;
        else if (tx_counter == (TX_DIV - 1))
            tx_counter <= 0;
        else
            tx_counter <= tx_counter + 1'b1;
    end

    // RX counter: counts up to RX_DIV-1, then resets
    always @(posedge clk) begin
        if (reset)
            rx_counter <= 0;
        else if (rx_counter == (RX_DIV - 1))
            rx_counter <= 0;
        else
            rx_counter <= rx_counter + 1'b1;
    end
    // tx_en pulses high for one clock cycle every TX_DIV cycles
    assign tx_en = (tx_counter == (TX_DIV - 1)) ? 1'b1 : 1'b0;

    // rx_en pulses high for one clock cycle every RX_DIV cycles
    assign rx_en = (rx_counter == (RX_DIV - 1)) ? 1'b1 : 1'b0;
endmodule
