package shift_reg_cover_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import shift_reg_seq_item_pkg::*;

  class shift_reg_cover extends uvm_component;
    `uvm_component_utils(shift_reg_cover)
    uvm_analysis_export #(shift_reg_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(shift_reg_seq_item) cov_fifo;
    shift_reg_seq_item seq_item_cov;

    covergroup cg;
        reset_cp: coverpoint seq_item_cov.reset;
        serial_in_cp: coverpoint seq_item_cov.serial_in;
        direction_cp: coverpoint seq_item_cov.direction;
        mode_cp: coverpoint seq_item_cov.mode;
        datain_cp: coverpoint seq_item_cov.datain;
    endgroup

    function new(string name = "shift_reg_cover", uvm_component parent = null);
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