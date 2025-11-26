class mux_monitor;
  virtual mux_if vif;
  mailbox #(mux_transaction) mon2scb_mb;

  function new(virtual mux_if vif, mailbox #(mux_transaction) mb);
	this.vif = vif;
	this.mon2scb_mb = mb;
  endfunction
  
  task run();
	mux_transaction t;
	forever begin
     
          t = new();
          t.mux_in = vif.mux_in;
          t.mux_sel_in = vif.mux_sel_in; 
          #100
          t.mux_out = vif.mux_out;
          t.display("monitor");
          mon2scb_mb.put(t);
          
      
      
   end
  endtask
endclass
