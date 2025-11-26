class mux_generator;
    mailbox #(mux_transaction) gen2drv_mb;
	int repeat_count;
    event ended;
  
    function new(mailbox #(mux_transaction) mb);
		this.gen2drv_mb = mb;
	endfunction
  
	task run();
		mux_transaction t;
		repeat (repeat_count) 
        begin
			t = new();
            if(!t.randomize()) $fatal ("randomization failed!!");
			assert(t.randomize());
            
        	t.display("generator");
			gen2drv_mb.put(t);
          
		end
      -> ended;
	endtask
endclass
