module TOP ();
  bit clk;
  always #10 clk = ~clk;

  FIFO_if intf (clk);
  FIFO DUT (intf);
  TB tb (intf);
  monitor MON (intf);

  always_comb begin
    if (!intf.rst_n)
      arst_sva: assert final(
                    intf.full == 0 &&
                    intf.almostfull == 0 &&
                    intf.empty == 1 && 
                    intf.almostempty == 0 &&
                    intf.overflow == 0 &&
                    intf.underflow == 0 &&
                    intf.data_out == 0 &&
                    intf.wr_ack == 0
                );
  end
endmodule