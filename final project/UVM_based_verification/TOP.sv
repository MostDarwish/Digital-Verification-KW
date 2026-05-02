import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test_pkg::*;
module TOP ();
  bit clk;
  always #1 clk = ~clk;

  FIFO_if intf (clk);
  FIFO DUT (intf);

  initial begin
    uvm_config_db #(virtual FIFO_if)::set(null, "uvm_test_top", "FIFO_IF", intf);
    run_test("FIFO_test");
  end

  bind FIFO FIFO_sva fifo_sva_inst (
      .fifo_if(intf),
      .count_dbg(DUT.count),
      .wr_ptr_dbg(DUT.wr_ptr),
      .rd_ptr_dbg(DUT.rd_ptr)
  );

endmodule