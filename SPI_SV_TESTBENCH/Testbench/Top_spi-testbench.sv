`timescale 1ns/1ps
`include "spi_if.sv"
`include "spi_test.sv"

module spi_tbench_top;

  bit clk = 0;
  bit rst;

  always #5 clk = ~clk;

  initial begin
    rst = 1;
    #10 rst = 0;
  end

  spi_if i_intf (clk, rst);

  spi_test t1 (i_intf);

  spi_top dut (
    .clk       (i_intf.clk),
    .rst       (i_intf.rst),
    .start     (i_intf.start),
    .m_data_in (i_intf.m_data_in),
    .s_data_in (i_intf.s_data_in),    // <-- now driven by TB
    .m_data_out(i_intf.m_data_out),   // <-- now observed
    .s_data_out(i_intf.s_data_out),
    .done      (i_intf.done)
  );

  initial begin
    $dumpfile("spi_dump.vcd");
    $dumpvars(0, spi_tbench_top);
  end

endmodule
