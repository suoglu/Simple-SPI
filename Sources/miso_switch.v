/* ------------------------------------------------ *
 * Title       : MISO Switch                        *
 * Project     : Simple SPI                         *
 * ------------------------------------------------ *
 * File        : miso_switch.v                      *
 * Author      : Yigit Suoglu                       *
 * Last Edit   : 08/12/2020                         *
 * Licence     : CERN-OHL-W                         *
 * ------------------------------------------------ *
 * Description : Route MISO signals, usefull when   *
 *               tri-state is not available         *
 * ------------------------------------------------ */

module MISO_switch#(parameter SLAVE_COUNT = 8)(
  input [SLAVE_COUNT-1:0] MISO_in,
  input [SLAVE_COUNT-1:0] CS,
  output MISO_out);
  
  reg [SLAVE_COUNT-1:0] MISO;

  integer i;
  always@*
    begin
      for(i = 0; i < SLAVE_COUNT; i = i + 1)
        begin
          MISO[i] <= (~CS[i]) & MISO_in[i];
        end
    end
  
  assign MISO_out = |MISO;

endmodule//MISO_switch