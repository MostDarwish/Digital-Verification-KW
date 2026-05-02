package FIFO_sqr_pkg;
  import uvm_pkg::*;
  import FIFO_seq_item_pkg::*;
  `include "uvm_macros.svh"
  
  class FIFO_sqr extends uvm_sequencer #(FIFO_seq_item);
    `uvm_component_utils(FIFO_sqr)

    function new(string name = "FIFO_sqr", uvm_component parent = null);
      super.new(name, parent);
    endfunction

  endclass

endpackage
