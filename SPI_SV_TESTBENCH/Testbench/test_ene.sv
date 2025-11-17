`include "spi_env.sv"

program spi_test (spi_if i_intf);

  spi_env env;

  initial begin
    env = new(i_intf);
    env.build();
    env.gen.repeat_count = 2;   // number of packets
    env.run();

    // run for enough time
    #10000;
    env.scb.report();
    $finish;
  end

endprogram
