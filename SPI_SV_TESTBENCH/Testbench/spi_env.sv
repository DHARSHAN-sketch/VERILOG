// spi_env.sv

`include "spi_transaction.sv"
`include "spi_generator.sv"
`include "spi_driver.sv"
`include "spi_scoreboard.sv"
`include "spi_monitor.sv"

class spi_env;

  virtual spi_if vif;
  spi_generator gen;
  spi_driver drv;
  spi_monitor mon;
  spi_scoreboard scb;

  mailbox #(spi_transaction) gen2drv_mb;
  mailbox #(spi_transaction) mon2scb_mb;

  function new(virtual spi_if vif);
    this.vif = vif;
  endfunction

  function void build();
    gen2drv_mb = new();
    mon2scb_mb = new();

    gen = new(gen2drv_mb);
    drv = new(vif, gen2drv_mb);
    mon = new(vif, mon2scb_mb);
    scb = new(mon2scb_mb);
  endfunction

  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_none
  endtask

endclass
