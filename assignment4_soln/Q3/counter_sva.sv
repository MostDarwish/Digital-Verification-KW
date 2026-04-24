module counter_sva(count_if.MONITOR intf);
    //? asynchronous reset assertion
    always_comb begin 
        if(!intf.rst_n) 
            arst_sva: assert final(intf.count_out == 0 && intf.max_count == 0 && intf.zero == 1);  
    end
    //? PROPERTIES
    property zero_sva_check;
        (@(posedge intf.clk) intf.count_out == 0 |-> intf.zero);
    endproperty
    property max_out_sva_check;
        (@(posedge intf.clk) intf.count_out == '1 |-> intf.max_count);
    endproperty
    property load_sva_check;
        @(posedge intf.clk) disable iff(!intf.rst_n) !intf.load_n |=> intf.count_out == $past(intf.data_load);
    endproperty
    property ce_load_off_sva_check;
        @(posedge intf.clk) disable iff(!intf.rst_n) !intf.ce && intf.load_n |=> intf.count_out == $past(intf.count_out);
    endproperty
    property up_sva_check;
        @(posedge intf.clk) disable iff(!intf.rst_n) intf.ce && intf.load_n && intf.up_down |=> intf.count_out == $past(intf.count_out) + 1'b1;
    endproperty
    property down_sva_check;
        @(posedge intf.clk) disable iff(!intf.rst_n) intf.ce && intf.load_n && !intf.up_down |=> intf.count_out == $past(intf.count_out) - 1'b1;
    endproperty
    //? ASSERTIONS
    zero_sva:        assert property (zero_sva_check);
    max_out_sva:     assert property (max_out_sva_check);
    load_sva:        assert property (load_sva_check) ;
    ce_load_off_sva: assert property (ce_load_off_sva_check);
    up_sva:          assert property (up_sva_check);
    down_sva:        assert property (down_sva_check);
    //? COVER PROPERTIES
    zero_sva_cp:        cover property (zero_sva_check);
    max_out_sva_cp:     cover property (max_out_sva_check);
    load_sva_cp:        cover property (load_sva_check) ;
    ce_load_off_sva_cp: cover property (ce_load_off_sva_check);
    up_sva_cp:          cover property (up_sva_check);
    down_sva_cp:        cover property (down_sva_check);

endmodule