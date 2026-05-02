package FIFO_cover_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import FIFO_seq_item_pkg::*;
  import shared_pkg::*;

  class FIFO_cover extends uvm_component;
    `uvm_component_utils(FIFO_cover)
    uvm_analysis_export #(FIFO_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
    FIFO_seq_item seq_item_cov;

    covergroup cg;
        wr_en_cp:       coverpoint seq_item_cov.wr_en;
        rd_en_cp:       coverpoint seq_item_cov.rd_en;
        wr_ack_cp:      coverpoint seq_item_cov.wr_ack;
        full_cp:        coverpoint seq_item_cov.full;
        almost_full_cp: coverpoint seq_item_cov.almostfull;
        empty_cp:       coverpoint seq_item_cov.empty;
        almostempty_cp: coverpoint seq_item_cov.almostempty;
        overflow_cp:    coverpoint seq_item_cov.overflow;
        underflow_cp:   coverpoint seq_item_cov.underflow;

        EN_CROSS_WR_ACK:       cross wr_en_cp, rd_en_cp, wr_ack_cp {ignore_bins EN_WR_ACK_IGN = binsof(wr_en_cp) intersect {0} && binsof(wr_ack_cp) intersect {1};}
        EN_CROSS_FULL:         cross wr_en_cp, rd_en_cp, full_cp { ignore_bins EN_FULL_IGN = binsof(rd_en_cp) intersect {1} && binsof(full_cp) intersect {1}; } 
        EN_CROSS_ALMOST_FULL:  cross wr_en_cp, rd_en_cp, almost_full_cp;
        EN_CROSS_EMPTY:        cross wr_en_cp, rd_en_cp, empty_cp;
        EN_CROSS_ALMOST_EMPTY: cross wr_en_cp, rd_en_cp, almostempty_cp;
        EN_CROSS_OVERFLOW:     cross wr_en_cp, rd_en_cp, overflow_cp {ignore_bins EN_OVFL_IGN = binsof(wr_en_cp) intersect {0} && binsof(overflow_cp) intersect {1};}
        EN_CROSS_UNDERFLOW:    cross wr_en_cp, rd_en_cp, underflow_cp { ignore_bins EN_UNFL_IGN = binsof(rd_en_cp) intersect {0} && binsof(underflow_cp) intersect {1}; }
    endgroup

    function new(string name = "FIFO_cover", uvm_component parent = null);
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
