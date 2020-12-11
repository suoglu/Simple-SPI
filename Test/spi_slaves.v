/* ------------------------------------------------- *
 * Title       : SPI Slaves for GPIO control         *
 * Project     : Simple SPI                          *
 * ------------------------------------------------- *
 * File        : spi_slaves.v                        *
 * Author      : Yigit Suoglu                        *
 * Last Edit   : 07/12/2020                          *
 * ------------------------------------------------- *
 * Description : Test SPI slaves modules on FPGA     *
 * ------------------------------------------------- */

//`include "Sources/spi.v"
//`include "Test/ssd_util.v"

module SPI_LED(
  input clk,
  input rst,
  input MOSI,
  output MISO,
  input SPI_SCLK,
  input CS,
  input [1:0] transaction_length,
  input CPOL,
  input CPHA,
  input display_high_bits,
  output [15:0] led);

  wire [31:0] tx, rx;

  assign tx = rx; //echo back prev
  assign led = (display_high_bits) ? rx[31:16] : rx[15:0];
  
  spi_slave spi(clk, rst, , MOSI, MISO, SPI_SCLK, CS, tx, rx,  transaction_length, CPOL, CPHA, 1'bZ);

endmodule//SPI_LED

module SPI_SSD(input clk,
  input rst,
  input MOSI,
  output MISO,
  input SPI_SCLK,
  input CS,
  input [1:0] transaction_length,
  input CPOL,
  input CPHA,
  input display_high_bits,
  output [3:0] an,
  output [6:0] seg);
  
  wire [31:0] tx, rx;
  wire a, b, c, d, e, f, g;
  wire [3:0] digit0, digit1, digit2, digit3;
  
  assign tx = rx; //echo back prev
  assign seg = {g, f, e, d, c, b, a};
  assign {digit3, digit2, digit1, digit0} = (display_high_bits) ? rx[31:16] : rx[15:0];

  ssdController4 ssd(clk, rst, 4'b1111, digit0, digit1, digit2, digit3, a, b, c, d, e, f, g, an);
  spi_slave spi(clk, rst, , MOSI, MISO, SPI_SCLK, CS, tx, rx,  transaction_length, CPOL, CPHA, 1'bZ);

endmodule//SPI_SSD
