package shift_reg_seq_item_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"
    class shift_reg_seq_item extends uvm_sequence_item;
        `uvm_object_utils(shift_reg_seq_item)

        rand bit serial_in;
        rand mode_e mode;
        rand direction_e direction;
        rand bit [5:0] datain;
        logic [5:0] dataout;

        function new(string name = "shift_reg_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s, serial_in = 0b%0b, mode = %s, direction = %s, datain = 0b%0b, dataout = 0b%0b",
            super.convert2string(), serial_in, mode.name(), direction.name(), datain, dataout);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("serial_in = 0b%0b, mode = %s, direction = %s, datain = 0b%0b, dataout = 0b%0b",
            serial_in, mode.name(), direction.name(), datain, dataout);
        endfunction

    endclass //shift_reg_seq_item extends superClass
endpackage