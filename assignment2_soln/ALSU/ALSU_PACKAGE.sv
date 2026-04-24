package ALSU_PACKAGE;
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    parameter MAXPOS = 3'b011;
    parameter MAXNEG = 3'b100;
    parameter ZERO = 3'b000;
    typedef enum logic [2:0] { OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7 } opcode_e;
    class ALSU_Rand_Var;
        rand bit rst, cin, serial_in, direction, red_op_A, red_op_B, bypass_A, bypass_B;
        rand opcode_e opcode;
        rand bit [2:0] A,B;

        function new();
            rst = 0;
            cin = 0;
            serial_in = 0;
            direction = 0;
            red_op_A = 0;
            red_op_B = 0;
            bypass_A = 0;
            bypass_B = 0;
            opcode = opcode_e'($random);
            A = $random;
            B = $random;  
        endfunction

        constraint constraints {
            rst dist {0:=99, 1:=1};
            bypass_A dist {0:=99, 1:=1};
            bypass_B dist {0:=99, 1:=1};
            opcode dist {INVALID_6:=10, INVALID_7:=10, [OR:ROTATE]:=90};
            if(opcode == OR || opcode == XOR){
                red_op_A dist {1:=20, 0:=80};
                red_op_B dist {1:=20, 0:=80};
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
    endclass
endpackage