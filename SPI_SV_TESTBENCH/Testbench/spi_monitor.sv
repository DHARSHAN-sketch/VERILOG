class spi_monitor;

  virtual spi_if vif;
  mailbox #(spi_transaction) mon2scb_mb;
  bit verbose = 1;

  function new(virtual spi_if vif, mailbox #(spi_transaction) mb);
    this.vif = vif;
    this.mon2scb_mb = mb;
  endfunction

  task run();
    spi_transaction t;
    forever begin
      @(posedge vif.clk);
      if (vif.done) begin
        t = new();
        t.m_data_in  = vif.m_data_in;
        t.s_data_in  = vif.s_data_in;   // <-- added
        t.s_data_out = vif.s_data_out;
        t.m_data_out = vif.m_data_out;  // <-- added

        if (verbose) begin
          $display("-----------------------------------");
          $display(" - monitor");
          $display("m_data_in  = %0d",  t.m_data_in);
          $display("s_data_in  = %0d",  t.s_data_in);   // <-- added
          $display("m_data_out = %0d",  t.m_data_out);  // <-- added
          $display("s_data_out = %0d",  t.s_data_out);
          $display("-----------------------------------");
        end
        mon2scb_mb.put(t);
      end
    end
  endtask

endclass
