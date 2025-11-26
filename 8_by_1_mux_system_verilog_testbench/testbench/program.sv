`include "mux_environment.sv"
program mux_test (mux_if i_intf);
	mux_env env;

	initial begin
	env = new(i_intf);
	env.build();
	env.gen.repeat_count = 100; 
    env.pre_test();  
	env.run();
    env.post_test();
	
	env.scb.report();
      
	$finish;
	end
endprogram

