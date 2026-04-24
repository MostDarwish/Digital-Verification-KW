package COUNTER_PACKAGE;
    parameter WIDTH = 4;
    class counter_var;
        rand bit rst_n, load_n, up_down, ce;
        rand bit [WIDTH-1:0] data_load;
        constraint c_dist {
            rst_n  dist {1:=95, 0:=5};
            load_n dist {0:=70, 1:=30};
            ce     dist {0:=30, 1:=70};
        }
    endclass
endpackage