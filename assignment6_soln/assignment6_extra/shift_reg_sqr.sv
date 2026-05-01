package shift_reg_sqr_pkg;
  import uvm_pkg::*;
  import shift_reg_seq_item_pkg::*;
  `include "uvm_macros.svh"
  
  class shift_reg_sqr extends uvm_sequencer #(shift_reg_seq_item);
    `uvm_component_utils(shift_reg_sqr)

    function new(string name = "shift_reg_sqr", uvm_component parent = null);
      super.new(name, parent);
    endfunction

  endclass

endpackage
