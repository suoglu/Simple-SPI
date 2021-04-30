/* ------------------------------------------------- *
 * Title       : Testbench for spi.v                 *
 * Project     : Simple SPI                          *
 * ------------------------------------------------- *
 * File        : tb.v                                *
 * Author      : Yigit Suoglu                        *
 * Last Edit   : 29/04/2021                          *
 * ------------------------------------------------- *
 * Description : Simulation for SPI modules in spi.v *
 * ------------------------------------------------- */

`timescale 1ns / 1ps
//`include "Sources/spi.v"

module testbench();
    reg clk, rst, start_trans, CPOL, CPHA;
    wire busy_m, busy_s, MOSI, SPI_SCLK, MISO;
    wire [31:0] rx_data_m, rx_data_s;
    wire [7:0] CS;
    reg [31:0] tx_data_m, tx_data_s;
    reg [1:0] transaction_length;
    wire spi_clk_ext;

    always #5 clk <= ~clk;

    pullup(MISO);

    //assign MISO = MOSI;
    spi_clk_gen spiClk(clk, rst, 4'd0, spi_clk_ext);
    spi_master master_uut(clk, rst, spi_clk_ext, start_trans, busy_m, MOSI, MISO, SPI_SCLK, CS, tx_data_m, rx_data_m, 3'd0, transaction_length, CPOL, CPHA, 1'b0);
    spi_slave slave_uut(clk, rst, busy_s, MOSI, MISO, SPI_SCLK, CS[0], tx_data_s, rx_data_s, transaction_length, CPOL, CPHA, 1'b0,1'b0);

//    initial //Tracked signals & Total sim time
//        begin
//          $dumpfile("Simulation/spi.vcd");
//          $dumpvars(0, clk);
//          $dumpvars(1, rst);
//          $dumpvars(2, transaction_length);
//          $dumpvars(3, CPOL);
//          $dumpvars(4, CPHA);
//          $dumpvars(5, MOSI);
//          $dumpvars(6, MISO);
//          $dumpvars(7, rx_data_m);
//          $dumpvars(8, tx_data_s);
//          $dumpvars(7, rx_data_s);
//          $dumpvars(8, tx_data_m);
//          $dumpvars(9, busy_m);
//          $dumpvars(10, busy_s);
//          $dumpvars(11, SPI_SCLK);
//          $dumpvars(12, CS);
//          $dumpvars(13, start_trans);
//         // $dumpvars(14, start_trans);
//          #3500
//          $finish;
//        end

    initial //initilizations and reset
        begin
            clk <= 0;
            rst <= 0;
            start_trans <= 0;
            CPHA <= 0;
            CPOL <= 0;
            transaction_length <= 2'd0;
            #3
            rst <= 1;
            #10
            rst <= 0;
        end

    initial //Testcases
        begin
          tx_data_m <= 32'b1010_1010; // AA
          tx_data_s <= 32'b1111_1011; //FB
          #40
          start_trans <= 1;
          #20
          start_trans <= 0;
          #450
          tx_data_m <= 32'b1100_1001_0010_0110_1010_0000_0101_1100;
          tx_data_s <= 32'b1111_1001_0111_0110_0011_0010_1101_0100;
          transaction_length <= 2'd3;
          #40
          start_trans <= 1;
          #20
          start_trans <= 0;
          #1500
          tx_data_m <= 32'b1010_1100_1101_1001;
          tx_data_s <= 32'b0101_1101_0110_1010;
          transaction_length <= 2'd1;
          #200
          start_trans <= 1;
          #20
          start_trans <= 0;  
        end
endmodule//testbench
