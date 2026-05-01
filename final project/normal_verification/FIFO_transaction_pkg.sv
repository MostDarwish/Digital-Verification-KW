package FIFO_transaction_pkg;
    import shared_pkg::*;
    class FIFO_transaction;
        rand logic rst_n;
        rand logic wr_en;
        rand logic rd_en;
        rand logic [FIFO_WIDTH-1:0] data_in;
        logic wr_ack;
        logic full;
        logic almostfull;
        logic empty;
        logic almostempty;
        logic overflow;
        logic underflow;
        logic [FIFO_WIDTH-1:0] data_out;
        int RD_EN_ON_DIST, WR_EN_ON_DIST;

        function new(int RD_EN_ON_DIST=30, int WR_EN_ON_DIST=70);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction

        constraint c_dist {
            rst_n dist {1:= 98, 0:= 2};
            wr_en dist {0:= 100-WR_EN_ON_DIST, 1:= WR_EN_ON_DIST};
            rd_en dist {0:= 100-RD_EN_ON_DIST, 1:= RD_EN_ON_DIST};
        }

    endclass
endpackage