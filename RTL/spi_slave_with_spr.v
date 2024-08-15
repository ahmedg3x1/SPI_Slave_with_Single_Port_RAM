module spi_slave_with_spr(clk, rst_n, SS_n, MOSI, MISO);
    input clk, rst_n, SS_n, MOSI;
    output MISO;
    
    wire [9:0] rx_data;
    wire [7:0] tx_data;
    wire rx_valid, tx_valid;

    spi_slave spi_slave_m(.clk(clk), .rst_n(rst_n), .SS_n(SS_n), .MOSI(MOSI), .MISO(MISO), .rx_data(rx_data), .rx_valid(rx_valid), .tx_data(tx_data), .tx_valid(tx_valid));
    spr spr_m(.clk(clk), .rst_n(rst_n), .din(rx_data), .rx_valid(rx_valid), .dout(tx_data), .tx_valid(tx_valid));
endmodule