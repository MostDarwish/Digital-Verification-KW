interface count_if (clk);
    parameter WIDTH = 4;
    input bit clk;
    logic rst_n, load_n, up_down, ce;
    logic [WIDTH-1:0] data_load, count_out;
    logic max_count, zero;

    modport TEST (
        input clk, count_out, max_count, zero,
        output rst_n, load_n, up_down, ce, data_load
    );

    modport DUT (
        input clk, rst_n, load_n, up_down, ce, data_load,
        output count_out, max_count, zero
    );

    modport MONITOR (
        input clk, rst_n, load_n, up_down, ce, data_load, count_out, max_count, zero
    );
endinterface