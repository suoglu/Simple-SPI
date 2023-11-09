
`timescale 1 ns / 1 ps

module spi_v1_0 #(
  // Parameters of Axi Slave Bus Interface S_AXI
  parameter AXI_DATA_WIDTH  = 32,
  parameter AXI_ADDR_WIDTH  = 4,
  // Parameters of Axi Slave Bus Interface AXIS
  parameter AXIS_TDATA_WIDTH  = 32,
  //Customization
  parameter AXI_DATA_EN = 1,
  parameter AXIS_DATA_EN = 0,
  parameter MAX_PACKAGE_SIZE = 8,
  parameter SLAVE_COUNT = 1,
  parameter CPOL = 0,
  parameter CPHA = 0,
  parameter DYNAMIC_MODE = 0,
  //Offsets
  parameter OFFSET_STATUS = 0,//0x0 (RO)
  parameter OFFSET_PACKAGE_SIZE = 8,//0x8 (RW)
  parameter OFFSET_CHIP_SELECT = 16,//0x10 (RW)
  parameter OFFSET_SPI_MODE = 24,//0x18 (RW)
  parameter OFFSET_DATA_IN = 32,//0x20 (WO)
  parameter OFFSET_DATA_OUT = 40,//0x28 (RO)
  parameter OFFSET_CS_DATA_IN = 128//0x80 (WO) <- Starting address for cs 0
)(
  input  aclk,
  input  aresetn,
  input  spi_clk, // << freq(aclk)
  // Ports of Axi Slave Bus Interface S_AXI
  input [AXI_ADDR_WIDTH-1:0] s_axi_awaddr,
  input  s_axi_awvalid,
  output s_axi_awready,
  input [AXI_DATA_WIDTH-1:0] s_axi_wdata,
  input  s_axi_wvalid,
  output s_axi_wready,
  output [1:0] s_axi_bresp,
  output s_axi_bvalid,
  input  s_axi_bready,
  input [AXI_ADDR_WIDTH-1:0] s_axi_araddr,
  input  s_axi_arvalid,
  output s_axi_arready,
  output [AXI_DATA_WIDTH-1:0] s_axi_rdata,
  output [1:0] s_axi_rresp,
  output s_axi_rvalid,
  input  s_axi_rready,

  // Ports of Axi Slave Bus Interface S_AXIS
  output s_axis_tready,
  input [AXIS_TDATA_WIDTH-1:0] s_axis_tdata,
  input  s_axis_tvalid,

  // Ports of Axi Master Bus Interface M_AXIS
  output m_axis_tvalid,
  output [AXIS_TDATA_WIDTH-1:0] m_axis_tdata,
  input  m_axis_tready,

  // SPI busses
  output reg m_spi_clk_o,
  output reg [SLAVE_COUNT-1:0] m_spi_cs_o,
  output m_spi_mosi_o,
  input  [SLAVE_COUNT-1:0] m_spi_miso_i
);
  localparam S_COUNT_SIZE = $clog2(SLAVE_COUNT);

  wire transfering;//todo

  //SPI clock handling and sync
  reg cpol, cpha; //todo
  reg spi_clk_d;

  always@(posedge aclk) begin
    m_spi_clk_o <= transfering ? spi_clk : cpol; //!gated clock
    spi_clk_d <= spi_clk;
  end

  wire posedgeShift = cpol ^ cpha;

  //Send Buffer
  wire useAXISdata = !AXI_DATA_EN || (AXIS_DATA_EN && s_axis_tvalid);
  wire [MAX_PACKAGE_SIZE-1:0] TxBuffer_i = useAXISdata ? s_axis_tdata[MAX_PACKAGE_SIZE-1:0]:
                                                          s_axi_wdata[MAX_PACKAGE_SIZE-1:0];
  reg  [MAX_PACKAGE_SIZE-1:0] TxBuffer;
  wire csNone = &m_spi_cs_o;
  reg csNone_d;
  always@(posedge aclk) begin
    csNone_d <= csNone;
  end
  wire loadNew = csNone_d && !csNone; //load new data into buffer
  wire shiftBuff = posedgeShift ? spi_clk && !spi_clk_d :  !spi_clk && spi_clk_d;
  always@(posedge aclk) begin
    if(loadNew) begin
      TxBuffer <= TxBuffer_i;
    end if(shiftBuff) begin
      TxBuffer <= TxBuffer >> 1;
    end
  end
  assign m_spi_mosi_o = TxBuffer[0];
endmodule
