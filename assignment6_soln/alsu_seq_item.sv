package alsu_seq_item_pkg;
    import uvm_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"

    class alsu_seq_item extends uvm_sequence_item;
        `uvm_object_utils(alsu_seq_item)

        rand bit cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        rand opcode_e opcode;
        rand bit [2:0] A,B;
        logic [15:0] leds;
        logic [5:0] out;
        

        function new(string name = "alsu_seq_item");
            super.new(name);
        endfunction

        constraint alsu_constraints {
            rst dist {0:=99, 1:=1};
            bypass_A dist {0:=99, 1:=1};
            bypass_B dist {0:=99, 1:=1};
            opcode dist {INVALID_6:=10, INVALID_7:=10, [OR:ROTATE]:=90};
            if(opcode == OR || opcode == XOR){
                red_op_A dist {1:=30, 0:=70};
                red_op_B dist {1:=30, 0:=70};
                if(red_op_A) {
                    $onehot(A);
                    B == 0;
                } else if(red_op_B){
                    $onehot(B);
                    A == 0;
                }
            } else if(opcode == ADD || opcode == MULT) {
                A dist {MAXPOS:=80, MAXNEG:=80, ZERO:=80, {3'd1,3'd2,3'd5,3'd6,3'd7}:=20};
                B dist {MAXPOS:=80, MAXNEG:=80, ZERO:=80, {3'd1,3'd2,3'd5,3'd6,3'd7}:=20};
                red_op_A dist {1:=1, 0:=99};
                red_op_B dist {1:=1, 0:=99};
            } else {
                red_op_A dist {1:=1, 0:=99};
                red_op_B dist {1:=1, 0:=99};
            }
        }

        function string convert2string();
            return $sformatf("%s reset = 0b%0b, red_op_A = 0b%0b, red_op_B = %s, bypass_A = %s, bypass_B = 0b%0b, direction = 0b%0b, serial_in = 0b%0b, opcode = %s, A = 0b%0b, B = 0b%0b",
            super.convert2string(), rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, opcode.name(), A, B);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("reset = 0b%0b, red_op_A = 0b%0b, red_op_B = %s, bypass_A = %s, bypass_B = 0b%0b, direction = 0b%0b, serial_in = 0b%0b, opcode = %s, A = 0b%0b, B = 0b%0b",
            rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, opcode.name(), A, B);
        endfunction

    endclass //alsu_seq_item extends superClass
endpackage