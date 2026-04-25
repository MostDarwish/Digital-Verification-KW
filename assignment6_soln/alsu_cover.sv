package alsu_cover_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import alsu_seq_item_pkg::*;
  import shared_pkg::*;

  class alsu_cover extends uvm_component;
    `uvm_component_utils(alsu_cover)
    uvm_analysis_export #(alsu_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(alsu_seq_item) cov_fifo;
    alsu_seq_item seq_item_cov;

    covergroup cg;
        A_cp: coverpoint seq_item_cov.A {
                bins A_data_0 = {0};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_data_default = default;
            }
            A_data_cp: coverpoint seq_item_cov.A iff (seq_item_cov.red_op_A) {
                bins A_data_walkingones[] = {3'b001, 3'b010, 3'b100};
            }
            B_cp: coverpoint seq_item_cov.B {
                bins B_data_0 = {0};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_default = default;
            }
            B_data_cp: coverpoint seq_item_cov.B iff (seq_item_cov.red_op_B && !seq_item_cov.red_op_A){
                bins B_data_walkingones[] = {3'b001, 3'b010, 3'b100};
            }
            opcode_cp: coverpoint seq_item_cov.opcode {
                bins Bins_shift[] = {SHIFT,ROTATE};
                bins Bins_arith[] = {ADD,MULT};
                bins Bins_bitwise[] = {OR,XOR};
                illegal_bins Bins_invalid = {INVALID_6,INVALID_7};
            }
            cin_cp: coverpoint seq_item_cov.cin iff (seq_item_cov.opcode == ADD);
            direction_cp: coverpoint seq_item_cov.direction iff(seq_item_cov.opcode inside {SHIFT, ROTATE});
            serial_in_cp: coverpoint seq_item_cov.serial_in iff(seq_item_cov.opcode == SHIFT);
            red_opA_cp: coverpoint seq_item_cov.red_op_A {option.weight = 0;}
            red_opB_cp: coverpoint seq_item_cov.red_op_B {
                option.weight = 0;
                bins red_op_B0 = {0};
                bins red_op_B1 = {1};
            }
            ALU_cross_1_cp: cross A_cp, B_cp, opcode_cp {
                option.cross_auto_bin_max = 0;
                bins A_B_cross = binsof(A_cp) && binsof(B_cp) && binsof(opcode_cp.Bins_arith);
            }
            ALU_cross_2_cp: cross A_data_cp, B_cp iff(seq_item_cov.opcode inside {OR,XOR}){
                option.cross_auto_bin_max = 0;
                bins A_walking_cross_B = binsof(A_data_cp) && binsof(B_cp.B_data_0);
            }
            ALU_cross_3_cp: cross B_data_cp, A_cp, opcode_cp{
                option.cross_auto_bin_max = 0;
                bins B_walking_cross_A = binsof(B_data_cp) && binsof(A_cp.A_data_0) && binsof(opcode_cp) intersect {OR,XOR};
            }
            ALU_cross_4_cp: cross red_opA_cp, red_opB_cp iff (seq_item_cov.opcode != OR && seq_item_cov.opcode != XOR) {
                option.cross_auto_bin_max = 0;
                bins invalid_case = binsof(red_opA_cp) intersect {1} || binsof(red_opB_cp.red_op_B1);
            }
        endgroup

    function new(string name = "alsu_cover", uvm_component parent = null);
        super.new(name, parent);
        cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export", this);
        cov_fifo = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(seq_item_cov);
            cg.sample();
        end
    endtask
  endclass
endpackage
