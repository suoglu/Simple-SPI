/* ------------------------------------------------- *
 * Title       : Test module for spi.v               *
 * Project     : Simple SPI                          *
 * ------------------------------------------------- *
 * File        : board.v                             *
 * Author      : Yigit Suoglu                        *
 * Last Edit   : 07/12/2020                          *
 * ------------------------------------------------- *
 * Description : Test SPI modules on FPGA            *
 * ------------------------------------------------- */

`include "Sources/spi.v"
`include "Test/ssd_util.v"
`include "Test/btn_debouncer.v"
//Comment out includes in vivado

module board(
  input clk, 
  input btnC, //reset
  input btnU,
  input btnL, 
  input btnR, 
  input btnD, 
  output [3:0] an,
  output [0:6] seg,
  input [15:0] sw,
  output [15:0] led,
  output [3:0] JB);
  
  wire rst;
  wire begin_ta;
  wire MOSI, MISO, SPI_SCLK, CPOL, CPHA;
  wire CS;
  wire [31:0] master_tx, slave_tx;
  wire [31:0] master_rx, slave_rx;
  wire mbusy, sbusy;
  wire display_high_bits;
  wire [1:0] transaction_length;
  wire [2:0] freq_adjust;
  wire a, b, c, d, e, f, g;
  wire [3:0] digit0, digit1, digit2, digit3;

  assign display_high_bits = sw[15]; //Show higher order bits on ssd and leds
  assign {CPOL, CPHA} = sw[14:13]; //Clock setting
  assign transaction_length = sw[12:11]; //transaction length
  assign freq_adjust = sw[10:8]; //Frequency adjustment
  assign seg = {a, b, c, d, e, f, g};

  assign {digit3, digit2, digit1, digit0} = (display_high_bits) ? master_rx[31:16] : master_rx[15:0];
  assign led = (display_high_bits) ? slave_rx[31:16] : slave_rx[15:0];
  assign slave_tx = slave_rx;

  
  assign rst = btnC;
  assign master_tx = {4{sw[7:0]}};

  debouncer debounce(clk, rst, (btnU | btnL | btnR | btnD), begin_ta);
  ssdController4 ssd(clk, rst, 4'b1111, digit0, digit1, digit2, digit3, a, b, c, d, e, f, g, an);

  //SPI signals avaible at JB
  assign JB[3] = MISO;
  assign JB[2] = MOSI;
  assign JB[1] = SPI_SCLK;
  assign JB[0] = CS;

  spi_slave slave(clk, rst, sbusy, MOSI, MISO,  SPI_SCLK, CS, slave_tx, slave_rx,  transaction_length, CPOL, CPHA, 1'b0);
  spi_master #(1, 1) master(clk, rst, begin_ta, mbusy, MOSI, MISO, SPI_SCLK, CS, master_tx, master_rx, 1'b0,  transaction_length, {freq_adjust, 1'b0}, CPOL, CPHA, 1'b0);
  
endmodule//board