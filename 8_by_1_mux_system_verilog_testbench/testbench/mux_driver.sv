class mux_driver;
    int no_transaction;
	virtual mux_if vif;
    mailbox #(mux_transaction) gen2drv_mb;

    function new(virtual mux_if vif, mailbox #(mux_transaction) mb);
		this.vif = vif;
		this.gen2drv_mb = mb;
	endfunction
  
	task reset_phase();
		$display("driver reset started --------------");
		vif.mux_in <= 8'h00;
		vif.mux_sel_in <= 8'h00;
		$display("driver reset ended--------------");
	endtask


  	task run();
		
        mux_transaction t;
		forever begin
          
		gen2drv_mb.get(t);
        vif.mux_in = t.mux_in;
		vif.mux_sel_in = t.mux_sel_in; 
        #100;  
		t.mux_out = vif.mux_out;
        t.display("Driver");
		no_transaction++;
        
          
		end
	endtask
  
endclass
