
`timescale 1 ns / 1 ps

module spi_v1_0 #(
  // Parameters of Axi Slave Bus Interface S_AXI
  parameter AXI_DATA_WIDTH  = 32,
  parameter AXI_ADDR_WIDTH  = 4,
  // Parameters of Axi Slave Bus Interface AXIS
  parameter S_AXIS_TDATA_WIDTH  = 32,
  parameter M_AXIS_TDATA_WIDTH  = 32,
  //Customization
  parameter AXI_DATA_EN = 1,
  parameter AXIS_DATA_EN = 0,
  parameter MAX_PACKAGE_SIZE = 8,
  parameter SLAVE_COUNT = 1,
  parameter CPOL = 0,
  parameter CPHA = 0,
  parameter DYNAMIC_MODE = 0,
  //Offsets
  parameter OFFSET_STATUS = 0,
  parameter OFFSET_PACKAGE_SIZE = 8,
  parameter OFFSET_CHIP_SELECT = 16,
  parameter OFFSET_SPI_MODE = 24,
  parameter OFFSET_DATA_IN = 32,
  parameter OFFSET_DATA_OUT = 40

)(
  input  aclk,
  input  aresetn,
  input  spi_clk, // << freq(aclk)
  // Ports of Axi Slave Bus Interface S_AXI
  input [S_AXI_ADDR_WIDTH-1 : 0] s_axi_awaddr,
  input  s_axi_awvalid,
  output  s_axi_awready,
  input [S_AXI_DATA_WIDTH-1 : 0] s_axi_wdata,
  input [(S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb,
  input  s_axi_wvalid,
  output  s_axi_wready,
  output [1 : 0] s_axi_bresp,
  output  s_axi_bvalid,
  input  s_axi_bready,
  input [S_AXI_ADDR_WIDTH-1 : 0] s_axi_araddr,
  input  s_axi_arvalid,
  output  s_axi_arready,
  output [S_AXI_DATA_WIDTH-1 : 0] s_axi_rdata,
  output [1 : 0] s_axi_rresp,
  output  s_axi_rvalid,
  input  s_axi_rready,

  // Ports of Axi Slave Bus Interface S_AXIS
  output  s_axis_tready,
  input [S_AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata,
  input  s_axis_tvalid,

  // Ports of Axi Master Bus Interface M_AXIS
  output  m_axis_tvalid,
  output [M_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata,
  input  m_axis_tready,

  // SPI busses
  output m_spi_clk_o,
  output [SLAVE_COUNT-1:0] m_spi_cs_o,
  output m_spi_mosi_o,
  input [SLAVE_COUNT-1:0] m_spi_miso_i
);

endmodule
