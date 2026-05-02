package FIFO_test_pkg;
    import uvm_pkg::*;
    import FIFO_env_pkg::*;
    import FIFO_config_obj_pkg::*;
    import FIFO_seq_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)

        FIFO_env env;
        FIFO_config_obj fifo_cfg;
        FIFO_main_seq main_seq;
        FIFO_reset_seq reset_seq;


        //? constructor
        function new(string name="FIFO_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        //? phases
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = FIFO_env::type_id::create("env",this);
            fifo_cfg = FIFO_config_obj::type_id::create("fifo_cfg");
            main_seq = FIFO_main_seq::type_id::create("main_seq");
            reset_seq = FIFO_reset_seq::type_id::create("reset_seq");

            if(!uvm_config_db #(virtual FIFO_if)::get(this,"","FIFO_IF", fifo_cfg.fifo_vif))
                `uvm_fatal("build_phase", "TEST - unable to get virtual interface")
            
            uvm_config_db #(FIFO_config_obj)::set(this,"*","CFG",fifo_cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase", "Reset asserted", UVM_LOW)
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "Reset deasserted", UVM_LOW)

            `uvm_info("run_phase", "main stimulus generation started", UVM_LOW)
            main_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "main stimulus generation ended", UVM_LOW)
            phase.drop_objection(this);
        endtask

    endclass
endpackage