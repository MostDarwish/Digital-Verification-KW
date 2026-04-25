package alsu_test_pkg;
    import uvm_pkg::*;
    import alsu_env_pkg::*;
    import alsu_config_obj_pkg::*;
    import alsu_seq_pkg::*;
    `include "uvm_macros.svh"

    class alsu_test extends uvm_test;
        `uvm_component_utils(alsu_test)

        alsu_env env;
        alsu_config_obj alsu_cfg;
        alsu_main_seq main_seq;
        alsu_reset_seq reset_seq;


        //? constructor
        function new(string name="alsu_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        //? phases
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = alsu_env::type_id::create("env",this);
            alsu_cfg = alsu_config_obj::type_id::create("alsu_cfg");
            main_seq = alsu_main_seq::type_id::create("main_seq");
            reset_seq = alsu_reset_seq::type_id::create("reset_seq");

            if(!uvm_config_db #(virtual ALSU_if)::get(this,"","ALSU_IF", alsu_cfg.alsu_vif))
                `uvm_fatal("build_phase", "TEST - unable to get virtual interface")
            
            uvm_config_db #(alsu_config_obj)::set(this,"*","CFG",alsu_cfg);
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