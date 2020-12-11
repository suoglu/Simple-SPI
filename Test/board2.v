/* ------------------------------------------------- *
 * Title       : Slave est module for spi.v v2       *
 * Project     : Simple SPI                          *
 * ------------------------------------------------- *
 * File        : board2.v                            *
 * Author      : Yigit Suoglu                        *
 * Last Edit   : 07/12/2020                          *
 * ------------------------------------------------- *
 * Description : Test SPI slave module using         *
 *               external SPI master                 *
 * ------------------------------------------------- */

//`include "Test/spi_slaves.v"
//`include "Sources/miso_switch.v"

module board2(
  input clk,
  input rst, //btnC
  input MOSI, //JB2
  output MISO, //JB3
  input SPI_SCLK, //JB1
  input [1:0] CS, //JB8, JB7
  input [1:0] transaction_length, //SW[1:0]
  input CPOL, //SW[2]
  input CPHA,  //SW[3]
  input display_high_bits, //SW[15]
  output [15:0] led,
  output [3:0] an,
  output [6:0] seg
 );
  
  wire MISO0, MISO1;

  MISO_switch#(2) misoSwitch({MISO1, MISO0}, CS, MISO);

   SPI_LED led_controller(clk, rst, MOSI, MISO0, SPI_SCLK, CS[0], transaction_length, CPOL, CPHA, display_high_bits, led);

   SPI_SSD ssd_controller(clk, rst, MOSI, MISO1, SPI_SCLK, CS[1], transaction_length, CPOL, CPHA, display_high_bits, an, seg);
endmodule//board