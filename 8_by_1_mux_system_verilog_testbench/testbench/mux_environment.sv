
`include "mux_transaction.sv"
`include "mux_generator.sv"
`include "mux_driver.sv"
`include "mux_scoreboard.sv"
`include "mux_monitor.sv"

class mux_env;

  virtual mux_if vif;
  mux_generator gen;
  mux_driver  drv;
  mux_monitor mon;
  mux_scoreboard scb;

  mailbox #(mux_transaction) gen2drv_mb;
  mailbox #(mux_transaction) mon2scb_mb;

  function new(virtual mux_if vif);
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

  task pre_test();
    drv.reset_phase();
  endtask
  
  
  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_none
  endtask

  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_count == drv.no_transaction);
    wait(gen.repeat_count == scb.no_transaction); 
  endtask 
  
endclass
