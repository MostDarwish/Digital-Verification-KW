package adder_pkg;
typedef enum logic signed [3:0] {MAXPOS = 4'd7, MAXNEG = -4'd8, ZERO = 0} val_t;

class rand_adder;

    rand bit reset;
    rand logic signed [3:0] A,B;
    bit clk;

    constraint constraints {
        reset dist {0:=99, 1:=1};
        A dist {MAXPOS:=80, MAXNEG:=80, ZERO:=80, [-7:-1]:=20, [1:6]:=20};
        B dist {MAXPOS:=80, MAXNEG:=80, ZERO:=80, [-7:-1]:=20, [1:6]:=20};
    }

    covergroup Covgrp_A;
        A_cp: coverpoint A {
            bins data_0 = {0};
            bins data_max = {MAXPOS};
            bins data_min = {MAXNEG};
            bins data_default = default;
        }

        A_transition_cp: coverpoint A {
            bins data_0max = {ZERO, MAXPOS};
            bins data_maxmin = {MAXPOS, MAXNEG};
            bins data_minmax = {MAXNEG, MAXPOS};
        }
    endgroup

    covergroup Covgrp_B;
        B_cp: coverpoint B {
            bins data_0 = {0};
            bins data_max = {MAXPOS};
            bins data_min = {MAXNEG};
            bins data_default = default;
        }

        B_transition_cp: coverpoint B {
            bins data_0max = {ZERO, MAXPOS};
            bins data_maxmin = {MAXPOS, MAXNEG};
            bins data_minmax = {MAXNEG, MAXPOS};
        }
    endgroup

    function new();
        Covgrp_A = new();
        Covgrp_B = new();
    endfunction

endclass
endpackage : adder_pkg