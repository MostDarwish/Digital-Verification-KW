import shared_pkg::*;
module FIFO_sva ( 
    FIFO_if.MONITOR fifo_if,
    input logic [max_fifo_addr-1:0] wr_ptr_dbg, rd_ptr_dbg,
    input logic [max_fifo_addr:0] count_dbg
);
  //? asynchronous reset assertion
  always_comb begin
    if (!fifo_if.rst_n)
      arst_sva :
      assert final(
                    fifo_if.full == 0 &&
                    fifo_if.almostfull == 0 &&
                    fifo_if.empty == 1 && 
                    fifo_if.almostempty == 0 &&
                    fifo_if.overflow == 0 &&
                    fifo_if.underflow == 0 &&
                    fifo_if.data_out == 0 &&
                    fifo_if.wr_ack == 0 &&
                    wr_ptr_dbg == 0 &&
                    rd_ptr_dbg == 0 && 
                    count_dbg == 0
                );
  end

  //? direct assertions
  always_ff @(posedge fifo_if.clk) begin
    assert (wr_ptr_dbg < FIFO_DEPTH);
    assert (rd_ptr_dbg < FIFO_DEPTH);
    assert (count_dbg  <= FIFO_DEPTH);
  end

  //? concurrent assertions properties
  property wr_ack_sva_check;
    @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) fifo_if.wr_en && count_dbg < FIFO_DEPTH |=> fifo_if.wr_ack;
  endproperty
  property overflow_sva_check;
    @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) fifo_if.wr_en && count_dbg == FIFO_DEPTH |=> fifo_if.overflow;
  endproperty
  property underflow_sva_check;
    @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) fifo_if.rd_en && count_dbg == 0 |=> fifo_if.underflow;
  endproperty
  property empty_sva_check;
    @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) count_dbg == 0 |-> fifo_if.empty;
  endproperty
  property full_sva_check;
    @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) count_dbg == FIFO_DEPTH |-> fifo_if.full;
  endproperty
  property almfull_sva_check;
    @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) count_dbg == FIFO_DEPTH - 1 |-> fifo_if.almostfull;
  endproperty
  property almemp_sva_check;
    @(posedge fifo_if.clk) disable iff (!fifo_if.rst_n) count_dbg == 1 |-> fifo_if.almostempty;
  endproperty
  property wr_ptr_wrap_sva_check;
    @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) wr_ptr_dbg == 7 && fifo_if.wr_en && count_dbg < FIFO_DEPTH |=> wr_ptr_dbg == 0;
  endproperty
  property rd_ptr_wrap_sva_check;
    @(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) rd_ptr_dbg == 7 && fifo_if.rd_en && count_dbg > 0 |=> rd_ptr_dbg == 0;
  endproperty

  //? ASSERTIONS
  wr_ack_sva :           assert property (wr_ack_sva_check);
  overflow_sva :         assert property (overflow_sva_check);
  underflow_sva :        assert property (underflow_sva_check);
  empty_sva :            assert property (empty_sva_check);
  full_sva :             assert property (full_sva_check);
  almfull_sva :          assert property (almfull_sva_check);
  almemp_sva :           assert property (almemp_sva_check);
  wr_ptr_wrap_sva :      assert property (wr_ptr_wrap_sva_check);
  rd_ptr_wrap_sva :      assert property (rd_ptr_wrap_sva_check);
  //? COVER PROPERTIES
  wr_ack_sva_cp :        cover property (wr_ack_sva_check);
  overflow_sva_cp :      cover property (overflow_sva_check);
  underflow_sva_cp :     cover property (underflow_sva_check);
  empty_sva_cp :         cover property (empty_sva_check);
  full_sva_cp :          cover property (full_sva_check);
  almfull_sva_cp :       cover property (almfull_sva_check);
  almemp_sva_cp :        cover property (almemp_sva_check);
  wr_ptr_wrap_sva_cp :   cover property (wr_ptr_wrap_sva_check);
  rd_ptr_wrap_sva_cp :   cover property (rd_ptr_wrap_sva_check);

endmodule
