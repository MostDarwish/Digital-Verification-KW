package alsu_sqr_pkg;
  import uvm_pkg::*;
  import alsu_seq_item_pkg::*;
  `include "uvm_macros.svh"
  
  class alsu_sqr extends uvm_sequencer #(alsu_seq_item);
    `uvm_component_utils(alsu_sqr)

    function new(string name = "alsu_sqr", uvm_component parent = null);
      super.new(name, parent);
    endfunction

  endclass

endpackage
