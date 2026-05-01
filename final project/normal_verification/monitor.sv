import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
import shared_pkg::*;
module monitor(FIFO_if.MONITOR intf);
    FIFO_transaction F_txn;
    FIFO_scoreboard F_scb;
    FIFO_coverage F_cvg;
    initial begin
        F_txn = new();
        F_scb = new();
        F_cvg = new();
        forever begin
            @TRIG;
            F_txn.rst_n       = intf.rst_n;
            F_txn.wr_en       = intf.wr_en;
            F_txn.rd_en       = intf.rd_en;
            F_txn.wr_ack      = intf.wr_ack;
            F_txn.full        = intf.full;
            F_txn.almostfull  = intf.almostfull; 
            F_txn.empty       = intf.empty;
            F_txn.almostempty = intf.almostempty;
            F_txn.overflow    = intf.overflow;
            F_txn.underflow   = intf.underflow;
            F_txn.data_in     = intf.data_in;
            F_txn.data_out    = intf.data_out;
            -> ACK;
            fork
                F_cvg.sample_data(F_txn);
                F_scb.check_data(F_txn);
            join
            if(test_finished)begin
                $display("error_count = %d, correct_count = %d", error_count, correct_count);
                $stop;
            end
        end
    end
endmodule