`include "8by1_mux.sv"

module top_module_design(
    input logic [7:0] in    ,
    input logic [2:0] sel,   
    output logic y       
);
  mux8to1 mux_top ( .in(in),.sel(sel), .y(y));
endmodule
