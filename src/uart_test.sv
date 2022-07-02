`timescale 1ns / 1ps


module uart_test(
    input logic clk,
    input logic RsRx,
    input logic btnC,
    output logic RsTx,
    output logic [3:0] an,
    output logic [6:0] seg,
    output logic [7:0] led
    );
    
    logic tx_full, rx_empty, btn_tick;
    logic [7:0] rec_data, rec_data1;
    logic reset;
    
    uart uart_unit
        (.clk(clk), .reset(reset), .rd_uart(btn_tick),
         .wr_uart(btn_tick), .rx(RsRx), .w_data(rec_data1),
         .tx_full(tx_full), .rx_empty(rx_empty),
         .r_data(rec_data), .tx(RsTx), .dvsr(10'b0101000101));
         
    debouncer btn_db_unit
        (.clk(clk), .reset(reset), .sw(btnC), .db(btn_tick));
         
    assign rec_data1 = rec_data + 1;
    assign led = rec_data;
    assign an = 4'b1110;
    assign reset = 1'b0;
    assign seg = {1'b1, ~tx_full, 2'b11, ~rx_empty, 3'b111};
endmodule
