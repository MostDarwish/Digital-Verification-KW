import FIFO_transaction_pkg::*;
import shared_pkg::*;
module TB(FIFO_if.TB intf);
    FIFO_transaction F_txn;
    initial begin
        F_txn = new();
        intf.rst_n = 0;
        intf.wr_en = 0;
        intf.rd_en = 0;
        intf.data_in = 0;
        @(negedge intf.clk);
        -> TRIG;
        @ACK;
        for(int i=0; i<10000; i++) begin
            assert(F_txn.randomize());
            intf.rst_n = F_txn.rst_n;
            intf.wr_en = F_txn.wr_en;
            intf.rd_en = F_txn.rd_en;
            intf.data_in = F_txn.data_in;
            @(negedge intf.clk);
            -> TRIG;
            @ACK;
        end
        test_finished = 1;
        ->TRIG;
    end
endmodule