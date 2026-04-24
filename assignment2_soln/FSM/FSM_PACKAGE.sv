package FSM_PACKAGE;
    typedef enum logic [1:0] { IDLE, ZERO, ONE, STORE } state_e;
    class fsm_transaction;
        //? variables
        rand bit rst;
        rand bit x;
        state_e state;
        bit y_exp;
        bit [9:0] user_count_exp;
        //? constructor
        function new();
            rst = 0;    
            x = 0;
            y_exp = 0;
            user_count_exp = 0;
            state = IDLE;
        endfunction
        //? constraints
        constraint c_dist {
            rst  dist {0:=98, 1:=2};
            x    dist {0:=67, 1:=33};
        }
    endclass
endpackage