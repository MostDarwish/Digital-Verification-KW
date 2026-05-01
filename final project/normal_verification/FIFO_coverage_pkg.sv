package FIFO_coverage_pkg;
    import FIFO_transaction_pkg::*;
    class FIFO_coverage;
        FIFO_transaction F_cvg_txn;

        covergroup CVG;
            wr_en_cp:       coverpoint F_cvg_txn.wr_en;
            rd_en_cp:       coverpoint F_cvg_txn.rd_en;
            wr_ack_cp:      coverpoint F_cvg_txn.wr_ack;
            full_cp:        coverpoint F_cvg_txn.full;
            almost_full_cp: coverpoint F_cvg_txn.almostfull;
            empty_cp:       coverpoint F_cvg_txn.empty;
            almostempty_cp: coverpoint F_cvg_txn.almostempty;
            overflow_cp:    coverpoint F_cvg_txn.overflow;
            underflow_cp:   coverpoint F_cvg_txn.underflow;

            EN_CROSS_WR_ACK:       cross wr_en_cp, rd_en_cp, wr_ack_cp {ignore_bins EN_WR_ACK_IGN = binsof(wr_en_cp) intersect {0} && binsof(wr_ack_cp) intersect {1};}
            EN_CROSS_FULL:         cross wr_en_cp, rd_en_cp, full_cp { ignore_bins EN_FULL_IGN = binsof(rd_en_cp) intersect {1} && binsof(full_cp) intersect {1}; } 
            EN_CROSS_ALMOST_FULL:  cross wr_en_cp, rd_en_cp, almost_full_cp;
            EN_CROSS_EMPTY:        cross wr_en_cp, rd_en_cp, empty_cp;
            EN_CROSS_ALMOST_EMPTY: cross wr_en_cp, rd_en_cp, almostempty_cp;
            EN_CROSS_OVERFLOW:     cross wr_en_cp, rd_en_cp, overflow_cp {ignore_bins EN_OVFL_IGN = binsof(wr_en_cp) intersect {0} && binsof(overflow_cp) intersect {1};}
            EN_CROSS_UNDERFLOW:    cross wr_en_cp, rd_en_cp, underflow_cp { ignore_bins EN_UNFL_IGN = binsof(rd_en_cp) intersect {0} && binsof(underflow_cp) intersect {1}; }
        endgroup

        function new ();
            CVG = new();
        endfunction

        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn = F_txn;
            CVG.sample();
        endfunction
    endclass
endpackage