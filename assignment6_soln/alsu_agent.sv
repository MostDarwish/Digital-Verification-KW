package alsu_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import alsu_seq_item_pkg::*;
  import alsu_sqr_pkg::*;
  import alsu_driver_pkg::*;
  import alsu_monitor_pkg::*;
  import alsu_config_obj_pkg::*;

  class alsu_agent extends uvm_agent;
    `uvm_component_utils(alsu_agent)
    alsu_sqr sqr;
    alsu_driver drv;
    alsu_monitor mon;
    alsu_config_obj alsu_cfg;
    uvm_analysis_port #(alsu_seq_item) agt_ap;

    function new(string name = "alsu_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = alsu_sqr::type_id::create("sqr", this);
        drv = alsu_driver::type_id::create("drv", this);
        mon = alsu_monitor::type_id::create("mon", this);
        alsu_cfg = alsu_config_obj::type_id::create("alsu_cfg");
        agt_ap = new("agt_ap", this);
        if(!uvm_config_db #(alsu_config_obj)::get(this,"","CFG",alsu_cfg)) begin
            `uvm_fatal("build_phase", "TEST - unable to get configuration object")    
        end
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.alsu_vif = alsu_cfg.alsu_vif;
        mon.alsu_vif = alsu_cfg.alsu_vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.mon_ap.connect(agt_ap);
    endfunction
  endclass

endpackage