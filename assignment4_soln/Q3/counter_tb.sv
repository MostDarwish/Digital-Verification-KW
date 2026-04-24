import COUNTER_PACKAGE::*;
module counter_tb (count_if.TEST intf);
  //? class object
  counter_var count_rand;
  //? Driver block
  initial begin
    //* initialization
    count_rand = new();
    intf.rst_n = 1;
    intf.load_n = 1;
    intf.up_down = 0;
    intf.ce = 0;
    intf.data_load = $random;
    //! RESET the design
    @(negedge intf.clk) intf.rst_n = 0;
    @(negedge intf.clk) intf.rst_n = 1;
    //! constrained randomization
    for (int i = 0; i<100; i++) begin
        assert(count_rand.randomize());
        intf.data_load = count_rand.data_load;
        intf.ce = count_rand.ce;
        intf.up_down = count_rand.up_down;
        intf.rst_n = count_rand.rst_n;
        intf.load_n = count_rand.load_n;
        @(negedge intf.clk);
    end 
    $stop;
  end
endmodule