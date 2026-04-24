module counter_wrapper(count_if.DUT intf);

    counter #(.WIDTH(intf.WIDTH)) u_counter (
        .clk (intf.clk),
        .rst_n (intf.rst_n),
        .load_n (intf.load_n),
        .up_down (intf.up_down),
        .ce (intf.ce),
        .data_load (intf.data_load),
        .count_out (intf.count_out),
        .max_count (intf.max_count),
        .zero (intf.zero)
    );
    
endmodule