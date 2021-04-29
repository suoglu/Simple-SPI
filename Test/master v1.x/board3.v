/* ------------------------------------------------- *
 * Title       : Master test module for spi.v        *
 * Project     : Simple SPI                          *
 * ------------------------------------------------- *
 * File        : board3.v                            *
 * Author      : Yigit Suoglu                        *
 * Last Edit   : 10/12/2020                          *
 * ------------------------------------------------- *
 * Description : Test SPI master module using        *
 *               external SPI slave                  *
 * ------------------------------------------------- */

//`include "Test/spi_slaves.v"
//`include "Sources/miso_switch.v"
// `include "Sources/spi.v"
// `include "Test/ssd_util.v"

module board3(
  input clk,
  input rst, //btnC
  output MOSI, //JB2
  input MISO, //JB3
  output SPI_SCLK, //JB4
  output CS, //JB1
  input [1:0] transaction_length, //SW[13:12]
  input CPOL, //SW[15]
  input CPHA,  //SW[14]
  output [15:0] led,
  output [3:0] an,
  output [6:0] seg,
  output busy, //JB7
  input [3:0] division_ratio,
  input [7:0] sw,
  input btnU); 

wire start_trans;
wire [31:0] tx_data, rx_data;
assign tx_data = {4{sw}};
assign led = rx_data[31:16];

debouncer deboun(clk, rst, btnU, start_trans);

ssdController4 ssd_cnt(clk, rst, 4'b1111, rx_data[3:0], rx_data[7:4], rx_data[11:8], rx_data[15:12], seg[0], seg[1], seg[2], seg[3], seg[4], seg[5], seg[6], an);

spi_master#(1) uut(clk, rst, start_trans, busy, MOSI, MISO, SPI_SCLK, CS, tx_data, rx_data, 1'b0, transaction_length, division_ratio,  CPOL,  CPHA, 1'b0);
  
endmodule//board