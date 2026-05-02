import shared_pkg::*;
interface FIFO_if(clk);
    input bit clk;
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic wr_ack;
    logic full;
    logic almostfull;
    logic empty;
    logic almostempty;
    logic overflow;
    logic underflow;
    logic [FIFO_WIDTH-1:0] data_in;
    logic [FIFO_WIDTH-1:0] data_out;

    modport DUT (
        input clk,
              rst_n,
              data_in,
              wr_en,
              rd_en,
        output wr_ack,
               full,
               almostfull,
               empty,
               almostempty,
               overflow,
               underflow,
               data_out
    );

    modport MONITOR (
        input clk, 
              rst_n,
              wr_en, 
              rd_en, 
              wr_ack, 
              full, 
              almostfull, 
              empty, 
              almostempty,
              overflow,
              underflow,
              data_in,
              data_out
    );
endinterface