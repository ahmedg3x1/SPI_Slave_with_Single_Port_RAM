vlib work
vlog ../RTL/spr.v ../RTL/spi_slave.v ../RTL/spi_slave_with_spr.v spi_slave_with_spr_tb.v
vsim -voptargs=+acc work.spi_slave_with_spr_tb
add wave -color white clk
add wave -color Magenta rst_n
add wave -color white SS_n
add wave MOSI
add wave MISO
add wave -radix hexadecimal dut/rx_data
add wave -color yellow dut/rx_valid
add wave -radix hexadecimal dut/tx_data
add wave -color yellow dut/tx_valid
run -all