////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
//
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_test_pkg::*;

module top();
  // Example 1
  // Clock generation
  bit clk;
  always #1 clk = ~clk;
  // Instantiate the interface and DUT
  shift_reg_if shift_regif (clk);
  shift_reg DUT (
    .clk (shift_regif.clk),
    .reset (shift_regif.reset),
    .serial_in (shift_regif.serial_in),
    .direction (shift_regif.direction),
    .mode (shift_regif.mode),
    .datain (shift_regif.datain),
    .dataout (shift_regif.dataout)
  );
  // run test using run_test task
  initial begin
    uvm_config_db#(virtual shift_reg_if)::set(null, "uvm_test_top", "SHIFT_REG_IF", shift_regif);
    run_test("shift_reg_test");
  end
endmodule
