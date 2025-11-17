class spi_transaction;

  // master->slave
  rand bit [7:0] m_data_in;   // master transmit data
  // slave->master
  rand bit [7:0] s_data_in;   // slave  transmit data   <-- added

  // Observed
  bit [7:0]      s_data_out;  // slave received data
  bit [7:0]      m_data_out;  // master received data  <-- added

  constraint data_range {
    m_data_in inside {[0:255]};
    s_data_in inside {[0:255]};  // <-- added
  }

  function void display(string tag = "");
    $display("-----------------------------------");
    $display(" - [%s]", tag);
    $display("m_data_in  = %0d", m_data_in);
    $display("s_data_in  = %0d", s_data_in);   // <-- added
    $display("m_data_out = %0d", m_data_out); // <-- added
    $display("s_data_out = %0d", s_data_out);
    $display("-----------------------------------");
  endfunction

endclass
