/* ------------------------------------------------- *
 * Title       : Tester module for spi master        *
 * Project     : Simple SPI                          *
 * ------------------------------------------------- *
 * File        : master_tester_v2.v                  *
 * Author      : Yigit Suoglu                        *
 * Last Edit   : 30/04/2021                          *
 * ------------------------------------------------- *
 * Description : Tests SPI master module on FPGA     *
 * ------------------------------------------------- */

module spi_master_testerv2(
  input clk,
  input rst,
  //Master module connection
  output start_trans,
  input busy, 
  input MOSI, 
  output MISO, 
  input SCLK,
  input CS, 
  output [31:0] tx_data, 
  input [31:0] rx_data,
  output [1:0] transaction_length,
  output CPOL,
  output CPHA,
  //Clock connection
  output [3:0] division_ratio,
  //Board connectons
  output [7:0] JC,
  input [15:0] sw,
  output [15:0] led,
  output [3:0] an,
  output [6:0] seg,
  output dp,
  input btnU,
  input btnD);
  reg halfSelect;
  wire [15:0] shownHalf;
  wire transfer, halfChange;

  assign JC[3:0] = {SCLK,MISO,MOSI,CS};
  assign JC[7:4] = {3'd0, busy};

  assign transaction_length = sw[15:14];
  assign division_ratio = sw[13:10];
  assign {CPOL,CPHA} = sw[9:8];

  assign MISO = MOSI; //Echo MOSI to MISO

  assign led = {busy};

  assign tx_data = {4{sw[7:0]}}; //LSB switch value is duplicated to word

  assign dp = halfSelect; //Dots show the displayed half
  assign shownHalf = (halfSelect) ? rx_data[31:16] : rx_data[15:0];

  always@(posedge clk) //Change displayed half
    begin
      if(rst)
        begin
          halfSelect <= 1'b0;
        end
      else
        begin
          halfSelect <= halfSelect ^ halfChange;
        end
    end
  
  //IO controllers
  ssdController4 ssdController(clk, rst, 4'b1111, shownHalf[15:12], shownHalf[11:8], shownHalf[7:4], shownHalf[3:0], seg, an);
  debouncer dbU(clk, rst, btnU, start_trans);
  debouncer dbD(clk, rst, btnD, halfChange);
endmodule