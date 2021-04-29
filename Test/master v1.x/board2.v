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
  input SPI_SCLK, //JB4
  input CS, //JB1
  input [1:0] transaction_length, //SW[1:0]
  input CPOL, //SW[2]
  input CPHA,  //SW[3]
  input display_high_bits, //SW[15]
  output [15:0] led,
  output [3:0] an,
  output [6:0] seg
 );

  wire [31:0] tx, rx;
  wire a, b, c, d, e, f, g;


  assign tx = rx; //echo back prev
  assign led = rx[31:16];
  assign seg = {g, f, e, d, c, b, a};

  ssdController4 ssdcntrl(clk, rst, 4'b1111, rx[3:0], rx[7:4], rx[11:8], rx[15:12], a, b, c, d, e, f, g, an);

  spi_slave spi(clk, rst, , MOSI, MISO, SPI_SCLK, CS, tx, rx,  transaction_length, CPOL, CPHA, 1'bZ);
  
endmodule//board