class spi_driver;

  virtual spi_if vif;
  mailbox #(spi_transaction) gen2drv_mb;
  bit verbose = 1;

  function new(virtual spi_if vif, mailbox #(spi_transaction) mb);
    this.vif = vif;
    this.gen2drv_mb = mb;
  endfunction

  task reset_phase();
    if (verbose) $display("driver reset started --------------");
    vif.start     <= 1'b0;
    vif.m_data_in <= 8'h00;
    vif.s_data_in <= 8'h00;   // <-- added default
    @(posedge vif.clk);
    wait (vif.rst == 1'b0);
    repeat (2) @(posedge vif.clk);
    if (verbose) $display("driver reset ended--------------");
  endtask

  task drive_one(spi_transaction t);
    // drive inputs
    vif.m_data_in <= t.m_data_in;
    vif.s_data_in <= t.s_data_in;   // <-- added drive
    @(posedge vif.clk);

    // 1-cycle start pulse
    vif.start <= 1'b1;
    @(posedge vif.clk);
    vif.start <= 1'b0;

    // wait for done
    wait (vif.done == 1'b1);
    @(posedge vif.clk);

    // capture outputs
    t.s_data_out = vif.s_data_out;
    t.m_data_out = vif.m_data_out;  // <-- added capture

    if (verbose) begin
      $display("-----------------------------------");
      $display(" - [driver]");
      $display("m_data_in  = %0d", t.m_data_in);
      $display("s_data_in  = %0d", t.s_data_in);   // <-- added
      $display("m_data_out = %0d", t.m_data_out); // <-- added
      $display("s_data_out = %0d", t.s_data_out);
      $display("-----------------------------------");
    end
  endtask

  task run();
    spi_transaction t;
    reset_phase();
    forever begin
      gen2drv_mb.get(t);
      drive_one(t);
    end
  endtask

endclass
