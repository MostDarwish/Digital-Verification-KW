package alsu_env_pkg;
    import uvm_pkg::*;
    import alsu_cover_pkg::*;
    import alsu_agent_pkg::*;
    `include "uvm_macros.svh"

    class alsu_env extends uvm_env;
        `uvm_component_utils(alsu_env)

        alsu_agent agt;
        alsu_cover cov;

        function new(string name="alsu_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agt = alsu_agent::type_id::create("agt",this);
            cov = alsu_cover::type_id::create("cov",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_ap.connect(cov.cov_export);
        endfunction
    endclass
endpackage