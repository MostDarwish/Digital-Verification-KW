module TOP();
    bit clk;
    always #1 clk = ~clk;
    count_if intf(clk);
    counter_wrapper count_wrap (intf);
    counter_tb TB(intf.TEST);
    bind counter_wrapper counter_sva counter_sva_inst(intf);
endmodule