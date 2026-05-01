package  alsu_seq_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    import alsu_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class alsu_reset_seq extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_reset_seq)
        alsu_seq_item seq_item;

        function new(string name = "alsu_seq");
            super.new(name);
        endfunction

        task body;
            seq_item = alsu_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst = 1;
            seq_item.cin = 0;
            seq_item.serial_in = 0;
            seq_item.direction = 0;
            seq_item.red_op_A = 0;
            seq_item.red_op_B = 0;
            seq_item.bypass_A = 0;
            seq_item.bypass_B = 0;
            seq_item.opcode = opcode_e'($random);
            seq_item.A = $random;
            seq_item.B = $random;  
            finish_item(seq_item);
        endtask
    endclass //shift_reg_seq extends superClass

    class alsu_main_seq extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_main_seq)
        alsu_seq_item seq_item;

        function new(string name = "alsu_seq_item");
            super.new(name);
        endfunction

        task body;
            seq_item = alsu_seq_item::type_id::create("seq_item");
            repeat(10000) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass //shift_reg_seq extends superClass
endpackage