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
        rand opcode_e opcode_arr[6];
        rand bit [2:0] A,B;
        bit clk;
        
        covergroup cvr_gp;
            A_cp: coverpoint A {
                bins A_data_0 = {0};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_data_default = default;
            }
            A_data_cp: coverpoint A iff (red_op_A) {
                bins A_data_walkingones[] = {3'b001, 3'b010, 3'b100};
            }
            B_cp: coverpoint B {
                bins B_data_0 = {0};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_default = default;
            }
            B_data_cp: coverpoint B iff (red_op_B && !red_op_A){
                bins B_data_walkingones[] = {3'b001, 3'b010, 3'b100};
            }
            ALU_cp: coverpoint opcode {
                bins Bins_shift[] = {SHIFT,ROTATE};
                bins Bins_arith[] = {ADD,MULT};
                bins Bins_bitwise[] = {OR,XOR};
                illegal_bins Bins_invalid = {INVALID_6,INVALID_7};
                bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
            }
        endgroup

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
            cvr_gp = new();
        endfunction

        constraint ass2_constraints {
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

        constraint ass3_constraints {
            //constraint valid scenario
            foreach (opcode_arr[i])
                opcode_arr[i] != INVALID_6 && opcode_arr[i] != INVALID_7;
            //constraint unique values
            foreach (opcode_arr[i])
                foreach (opcode_arr[j])
                    if (i < j) opcode_arr[i] != opcode_arr[j];
        }

    endclass
endpackage