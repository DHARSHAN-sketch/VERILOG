interface spi_if (input logic clk, rst);

  // SPI top-level control and data
  logic start;
  logic [7:0] m_data_in;     // master transmit data
  logic [7:0] s_data_in;     // slave  transmit data  <-- added
  logic [7:0] s_data_out;    // slave received data
  logic [7:0] m_data_out;    // master received data  <-- added
  logic done;

endinterface
