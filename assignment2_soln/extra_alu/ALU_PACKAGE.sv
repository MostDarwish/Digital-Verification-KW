package ALU_PACKAGE;
    typedef enum logic [1:0] { Add, Sub, Not_A, ReductionOR_B } opcode_e;
    class ALU_R;
        rand bit reset;
        rand opcode_e opcode;
        rand bit [3:0] A,B;
        constraint c_dist {reset  dist {0:=98, 1:=2};}
    endclass
endpackage