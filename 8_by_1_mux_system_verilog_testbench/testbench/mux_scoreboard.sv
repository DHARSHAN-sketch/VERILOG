class mux_scoreboard;
  mailbox #(mux_transaction) mon2scb_mb;
	int no_transaction, pass, fail;

    function new(mailbox #(mux_transaction) mb);
		this.mon2scb_mb = mb;
	endfunction
  
	task run();
		mux_transaction t;
		forever begin
			mon2scb_mb.get(t);
			no_transaction++;
    		t.display("[scoreboard]");
            if ( t.mux_in[t.mux_sel_in]==t.mux_out) begin
                pass++;
                $display("result as expected");
            end 
            else begin
                fail++;
              $error(" incorect output !! : Expected_op = %0d, mux_op = %0d", t.mux_in[t.mux_sel_in],  t.mux_out);

            end
		end
	endtask
  
function void report();
  $display("=================================================");
  $display(" SPI SCOREBOARD SUMMARY ");
  $display(" Total Transactions: %0d Pass: %0d Fail: %0d", no_transaction, pass, fail);
  $display("=================================================");
endfunction
endclass
