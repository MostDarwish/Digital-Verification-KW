package shift_reg_driver_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import shift_reg_config_pkg::*;

  class shift_reg_driver extends uvm_driver;
    `uvm_component_utils(shift_reg_driver)
    virtual shift_reg_if shift_reg_vif;
    shift_reg_config shift_reg_cfg;

    function new(string name = "shift_reg_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(shift_reg_config)::get(this, "", "CFG", shift_reg_cfg))
        `uvm_fatal("build_phase", "unable to get configuration object")
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      shift_reg_vif = shift_reg_cfg.shift_reg_vif;
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      shift_reg_vif.reset = 1;
      shift_reg_vif.serial_in = 0;
      shift_reg_vif.direction = 0;
      shift_reg_vif.mode = 0;
      shift_reg_vif.datain = 6'b111000;
      @(negedge shift_reg_vif.clk);
      shift_reg_vif.reset = 0;
      forever begin
        @(negedge shift_reg_vif.clk);
        shift_reg_vif.serial_in = $random;
        shift_reg_vif.direction = 0;
        shift_reg_vif.mode = 0;
        shift_reg_vif.datain = 6'b111000;
      end
    endtask
  endclass

endpackage
