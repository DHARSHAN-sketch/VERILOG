class spi_scoreboard;

  mailbox #(spi_transaction) mon2scb_mb;
  int total, pass, fail;
  bit verbose = 1;

  function new(mailbox #(spi_transaction) mb);
    this.mon2scb_mb = mb;
  endfunction
  
  task run();
    bit ok_ms;
    bit ok_sm ;
    spi_transaction t;
    forever begin
      mon2scb_mb.get(t);
      total++;

      // Print transaction header
      $display("-----------------------------------");
      $display(" - [scoreboard]");
      $display("Expected M->S : %0d", t.m_data_in);
      $display("Observed S_out: %0d", t.s_data_out);
      $display("Expected S->M : %0d", t.s_data_in);   // <-- added
      $display("Observed M_out: %0d", t.m_data_out);  // <-- added
      $display("-----------------------------------");

      // Comparisons
      ok_ms = (t.s_data_out == t.m_data_in); // M->S
      ok_sm = (t.m_data_out == t.s_data_in); // S->M

      if (ok_ms && ok_sm) begin
        pass++;
        $display("result as expected (M->S and S->M correct)");
      end else begin
        fail++;
        if (!ok_ms)
          $error(" M->S mismatch: Expected = %0d, Got = %0d", t.m_data_in, t.s_data_out);
        if (!ok_sm)
          $error("S->M mismatch: Expected = %0d, Got = %0d", t.s_data_in, t.m_data_out);
      end
    end
  endtask

  function void report();
    $display("===================================");
    $display(" SPI SCOREBOARD SUMMARY ");
    $display("  Total: %0d  Pass: %0d  Fail: %0d", total, pass, fail);
    $display("===================================");
  endfunction

endclass
