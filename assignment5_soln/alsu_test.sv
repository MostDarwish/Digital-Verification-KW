package alsu_test_pkg;
    import uvm_pkg::*;
    import alsu_env_pkg::*;
    import alsu_config_obj_pkg::*;
    `include "uvm_macros.svh"

    class alsu_test extends uvm_test;
        //? factory register
        `uvm_component_utils(alsu_test)
        //? child object handle creation
        alsu_env env;
        //? configuration object handle creation
        alsu_config_obj alsu_config_obj_test;
        //? constructor
        function new(string name="alsu_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        //? phases
        //* build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = alsu_env::type_id::create("env",this);
            alsu_config_obj_test = alsu_config_obj::type_id::create("alsu_config_obj_test");
            uvm_config_db #(virtual ALSU_if)::get(this,"","ALSU_IF", alsu_config_obj_test.alsu_config_vif);
            uvm_config_db #(alsu_config_obj)::set(this,"*","CFG",alsu_config_obj_test);
        endfunction
        //* run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            #100; `uvm_info("run_phase", "Inside the ALSU test", UVM_MEDIUM)
            phase.drop_objection(this);
        endtask

    endclass
endpackage