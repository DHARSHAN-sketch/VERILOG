
`include "mux_interface.sv"
`include "mux_test.sv"

module mux_tbench_top;

  mux_if i_intf() ;
  mux_test t1 (i_intf);

  top_module_design dut (.in  (i_intf.mux_in),.sel  (i_intf.mux_sel_in),.y (i_intf.mux_out) );

  initial begin
    $dumpfile("spi_dump.vcd");
    $dumpvars(0,mux_tbench_top);
  end
endmodule
