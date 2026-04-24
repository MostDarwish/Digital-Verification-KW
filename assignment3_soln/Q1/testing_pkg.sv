package testing_pkg;
localparam MAXNEG = -128;
localparam MAXPOS = 127;
localparam ZERO = 0;
typedef enum logic [1:0] {ADD, SUB, MULT, DIV} opcode_e;

class Transaction;

    rand opcode_e opcode;
    rand byte operand1;
    rand byte operand2;
    bit clk;

    constraint constraints {
        operand1 dist {MAXPOS:=70, MAXNEG:=90, ZERO:=70};
        opcode != DIV;
    }

    covergroup CovCode @(posedge clk);
        operand1_cp: coverpoint operand1 {
            bins max_neg = {-128};
            bins zero = {0};
            bins max_pos = {127};
            bins misc = default;
        }

        opcode_cp: coverpoint opcode {
            bins add_sub = {ADD, SUB};
            bins add = {ADD};
            bins sub = {SUB};
            bins mult = {MULT};
            bins add_then_sub = (ADD => SUB);
            illegal_bins no_div = {DIV};
        }

        opcode_operand1: cross opcode_cp, operand1_cp {
            option.weight = 5;
            option.cross_auto_bin_max = 0;
            bins max_pos_add_or_sub = binsof(operand1_cp.max_pos) && binsof(opcode_cp.add_sub);
            bins max_neg_add_or_sub = binsof(operand1_cp.max_neg) && binsof(opcode_cp.add_sub);
        }

    endgroup

    function new();
        CovCode = new();
    endfunction

endclass // Transaction
endpackage : testing_pkg