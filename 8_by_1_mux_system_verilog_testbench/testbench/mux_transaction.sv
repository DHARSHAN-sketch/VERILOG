class mux_transaction;
  rand bit [7:0] mux_in; 
  rand bit [2:0] mux_sel_in; 
  bit  mux_out;
  
  constraint data_range {
    mux_in inside {[8'h00 : 8'hFF]};   
    mux_sel_in inside {[3'h0 : 3'h7]}; 
  }
  
  function void display(string tag = "");
    $display("-----------------------------------");
    $display(" - [%s]", tag);
    $display("muxinput = %08b", mux_in);
    $display("mux select line = %0d", mux_sel_in); 
    $display("mux_data_out = %0b", mux_out);
    $display("-----------------------------------");
  endfunction
endclass
