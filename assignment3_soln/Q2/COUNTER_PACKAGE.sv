package COUNTER_PACKAGE;
    parameter WIDTH = 4;
		parameter MAX_COUNT = 2**WIDTH-1;
    class counter_var;
        rand bit rst_n, load_n, up_down, ce;
        rand bit [WIDTH-1:0] data_load;
				bit clk;
				bit [WIDTH-1:0] count_out;
        constraint c_dist {
            rst_n  dist {1:=95, 0:=5};
            load_n dist {0:=70, 1:=30};
            ce     dist {0:=30, 1:=70};
        }

				covergroup CovCode @(posedge clk);
						reset: coverpoint rst_n {
								bins rst_0 = {0};
								bins rst_1 = {1};
								option.weight = 0;
						}
						load_en: coverpoint load_n{
								bins loaden_0 = {0};
								bins loaden_1 = {1};
								option.weight = 0;
						}
						clk_en: coverpoint ce {
								bins ce_0 = {0};
								bins ce_1 = {1};
								option.weight = 0;
						}
						up_down: coverpoint up_down {
								bins up_down_0 = {0};
								bins up_down_1 = {1};
								option.weight = 0;
						}
						data_load_cp: coverpoint data_load {option.weight = 0;}
						count_out_cp: coverpoint count_out{
								bins max_to_zero = (MAX_COUNT => 0);
								bins zero_to_max = (0 => MAX_COUNT);
								bins misc = {[0:MAX_COUNT]};
						}
						//? CROSS COVERAGE PART
						data_load_cross_cp: cross data_load_cp, load_en, reset{
							option.cross_auto_bin_max = 0;
							bins data_load = binsof(reset.rst_1) && binsof(load_en.loaden_1) && binsof(data_load_cp);
						}

						count_out_up_cross_cp: cross count_out_cp, reset, clk_en, up_down {
							option.cross_auto_bin_max = 0;
							bins count_out = binsof(reset.rst_1) && binsof(clk_en.ce_1) && 
															 binsof(up_down.up_down_1) && binsof(count_out_cp.misc);
						}

						count_out_mto0tr_cross_cp: cross count_out_cp, reset, clk_en, up_down{
							option.cross_auto_bin_max = 0;
							bins count_out = binsof(reset.rst_1) && binsof(clk_en.ce_1) &&
														   binsof(up_down.up_down_1) && binsof(count_out_cp.max_to_zero);
						}

						count_out_down_cross_cp: cross count_out_cp, reset, clk_en, up_down {
							option.cross_auto_bin_max = 0;
							bins count_out = binsof(reset.rst_1) && binsof(clk_en.ce_1) && 
															 binsof(up_down.up_down_0) && binsof(count_out_cp.misc);
						}

						count_out_0tomtr_cross_cp: cross count_out_cp, reset, clk_en, up_down{
							option.cross_auto_bin_max = 0;
							bins count_out = binsof(reset.rst_1) && binsof(clk_en.ce_1) &&
														   binsof(up_down.up_down_0) && binsof(count_out_cp.zero_to_max);
					}

				endgroup

				function new();
						CovCode = new();
				endfunction

    endclass
endpackage