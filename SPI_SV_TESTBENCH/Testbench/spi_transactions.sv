class spi_generator;

  mailbox #(spi_transaction) gen2drv_mb;
  int repeat_count = 5;
  bit verbose = 1;

  function new(mailbox #(spi_transaction) mb);
    this.gen2drv_mb = mb;
  endfunction

  task run();
    spi_transaction t;
    repeat (repeat_count) begin
      t = new();
      assert(t.randomize());
      if (verbose) t.display("generator");
      gen2drv_mb.put(t);
    end
  endtask

endclass
