package FIFO_seq_item_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_seq_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_seq_item)

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
        

        function new(string name = "FIFO_seq_item", int RD_EN_ON_DIST=30, int WR_EN_ON_DIST=70);
            super.new(name);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction

        constraint c_dist {
            rst_n dist {1:= 98, 0:= 2};
            wr_en dist {0:= 100-WR_EN_ON_DIST, 1:= WR_EN_ON_DIST};
            rd_en dist {0:= 100-RD_EN_ON_DIST, 1:= RD_EN_ON_DIST};
        }

        function string convert2string();
            return $sformatf("%s reset = 0b%0b,\n wr_en = 0b%0b,\n rd_en = 0b%0b,\n data_in = 0h%0h,\n wr_ack = 0b%0b,\n full = 0b%0b,\n almostfull = 0b%0b,\n empty = 0b%0b,\n almostempty = 0b%0b,\n overflow = 0b%0b,\n underflow = 0b%0b,\n data_out = 0h%0h,\n",
            super.convert2string(), rst_n, wr_en, rd_en, data_in, wr_ack, full, almostfull, empty, almostempty, overflow, underflow, data_out);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("reset = 0b%0b,\n wr_en = 0b%0b,\n rd_en = 0b%0b,\n data_in = 0h%0h,\n wr_ack = 0b%0b,\n full = 0b%0b,\n almostfull = 0b%0b,\n empty = 0b%0b,\n almostempty = 0b%0b,\n overflow = 0b%0b,\n underflow = 0b%0b,\n data_out = 0h%0h,\n",
            rst_n, wr_en, rd_en, data_in, wr_ack, full, almostfull, empty, almostempty, overflow, underflow, data_out);
        endfunction

    endclass
endpackage