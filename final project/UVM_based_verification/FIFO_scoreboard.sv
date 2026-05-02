package FIFO_scoreboard_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import FIFO_seq_item_pkg::*;
  import shared_pkg::*;
    
  class FIFO_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(FIFO_scoreboard)
    uvm_analysis_export #(FIFO_seq_item) scb_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) scb_fifo;
    FIFO_seq_item seq_item_sb;
    int error_count = 0;
    int correct_count = 0;
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic [FIFO_WIDTH-1:0] FIFO_ref [$];

    function new(string name = "FIFO_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scb_export = new("scb_export", this);
        scb_fifo = new("scb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        scb_export.connect(scb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            scb_fifo.get(seq_item_sb);
            ref_model(seq_item_sb);
            `ifdef FULL_DEBUG
                if (seq_item_sb.data_out === data_out_ref) begin
                    correct_count++;
                    $display("correct output at time:%0t", $time);
                    $display("input stimulus: write_enable = %b, read_enable = %b, data_in = %0h output = %0h", seq_item_sb.wr_en, seq_item_sb.rd_en, seq_item_sb.data_in, seq_item_sb.data_out);
                    $display("expected current FIFO content:");
                    foreach (FIFO_ref[i]) begin
                        $display("FIFO[%0d] = %0h", i, FIFO_ref[i]);
                    end
                    $display("*********************************************************\n*********************************************************\n");
                end
            `else
                if (seq_item_sb.data_out === data_out_ref) correct_count++;
            `endif
            else begin
                error_count++;
                $display("error at time:%0t, the expected output = %0h, the actual output = %0h",
                $time, data_out_ref, seq_item_sb.data_out);
                $display("input stimulus: write_enable = %b, read_enable = %b, data_in = %0h", seq_item_sb.wr_en, seq_item_sb.rd_en, seq_item_sb.data_in);
                $display("expected current FIFO content:");
                foreach (FIFO_ref[i]) begin
                    $display("FIFO[%0d] = %0h", i, FIFO_ref[i]);
                end
                $display("*********************************************************\n*********************************************************\n");
            end
        end
    endtask

    function void ref_model (FIFO_seq_item seq_item_sb_chk);
            if (!seq_item_sb_chk.rst_n) begin
                FIFO_ref.delete();
                data_out_ref = 0;
            end

            else if(seq_item_sb_chk.wr_en && seq_item_sb_chk.rd_en && FIFO_ref.size() == FIFO_DEPTH)
                data_out_ref = FIFO_ref.pop_front();
            
            else if(seq_item_sb_chk.wr_en && seq_item_sb_chk.rd_en && FIFO_ref.size() == 0)
                FIFO_ref.push_back(seq_item_sb_chk.data_in);
            
            else begin
                if(seq_item_sb_chk.wr_en && FIFO_ref.size() < FIFO_DEPTH) FIFO_ref.push_back(seq_item_sb_chk.data_in);
                if(seq_item_sb_chk.rd_en && FIFO_ref.size() > 0) data_out_ref = FIFO_ref.pop_front();
            end
        endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase", $sformatf("total successful transactions: %0d", correct_count), UVM_MEDIUM);
        `uvm_info("report_phase", $sformatf("total failed transactions: %0d", error_count), UVM_MEDIUM);
    endfunction
  endclass
endpackage