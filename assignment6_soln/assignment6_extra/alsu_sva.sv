module alsu_sva(ALSU_if.MONITOR alsuif);
    import shared_pkg::*;
    bit invalid, normal_op;
    int correct_count, error_count;
    //? asynchronous reset assertion
    always_comb begin 
        if(alsuif.rst) 
            arst_sva: assert final(alsuif.leds == 0 && alsuif.out == 0);  
    end
    assign invalid = ( (alsuif.red_op_A | alsuif.red_op_B) & (alsuif.opcode[1] | alsuif.opcode[2]) ) | (alsuif.opcode[1] & alsuif.opcode[2]);
    assign normal_op = ~alsuif.bypass_A & ~alsuif.bypass_B & ~invalid;
    //? PROPERTIES
    property invalid_leds_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) invalid && !alsuif.bypass_A && !alsuif.bypass_B |=> 
                                                      ##1 alsuif.leds == ~$past(alsuif.leds);
    endproperty

    property bypassA_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) alsuif.bypass_A |=> 
                                                      ##1 alsuif.out == $past(alsuif.A,2);
    endproperty

    property bypassB_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) alsuif.bypass_B && !alsuif.bypass_A |=> 
                                                      ##1 alsuif.out == $past(alsuif.B,2);
    endproperty

    property invalid_out_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) !alsuif.bypass_A && !alsuif.bypass_B && invalid |=> ##1 alsuif.out == 0;
    endproperty

    property red_ora_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == OR && alsuif.red_op_A |=> 
                                                      ##1 alsuif.out == |$past(alsuif.A,2);
    endproperty

    property red_orb_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == OR && alsuif.red_op_B && !alsuif.red_op_A |=> 
                                                      ##1 alsuif.out == |$past(alsuif.B,2);
    endproperty

    property btw_or_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == OR && !alsuif.red_op_A && !alsuif.red_op_B |=> 
                                                      ##1 alsuif.out == $past(alsuif.A,2) | $past(alsuif.B,2);
    endproperty

    property red_xora_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == XOR && alsuif.red_op_A |=> 
                                                      ##1 alsuif.out == ^$past(alsuif.A,2);
    endproperty

    property red_xorb_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == XOR && alsuif.red_op_B && !alsuif.red_op_A |=>
                                                       ##1 alsuif.out == ^$past(alsuif.B,2);
    endproperty

    property btw_xor_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == XOR && !alsuif.red_op_A && !alsuif.red_op_B |=>
                                                       ##1 alsuif.out == $past(alsuif.A,2) ^ $past(alsuif.B,2);
    endproperty

    property add_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == ADD |=>
                                                       ##1 alsuif.out == $signed(6'($past(alsuif.A, 2))) + $signed(6'($past(alsuif.B, 2))) + $past(alsuif.cin, 2);
    endproperty

    property mult_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == MULT |=>
                                                       ##1 alsuif.out == $past(alsuif.A,2) * $past(alsuif.B,2);
    endproperty

    property shift_left_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == SHIFT && alsuif.direction |=>
                                                       ##1 alsuif.out == {$past(alsuif.out[4:0]), $past(alsuif.serial_in,2)};
    endproperty

    property shift_right_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == SHIFT && !alsuif.direction|=>
                                                       ##1 alsuif.out == {$past(alsuif.serial_in,2), $past(alsuif.out[5:1])};
    endproperty

    property rotate_left_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == ROTATE && alsuif.direction|=>
                                                       ##1 alsuif.out == {$past(alsuif.out[4:0]), $past(alsuif.out[5])};
    endproperty

    property rotate_right_sva_check;
        @(posedge alsuif.clk) disable iff(alsuif.rst) normal_op && alsuif.opcode == ROTATE && !alsuif.direction|=>
                                                       ##1 alsuif.out == {$past(alsuif.out[0]), $past(alsuif.out[5:1])};
    endproperty

    //? ASSERTIONS
    invalid_leds_sva:      assert property (invalid_leds_sva_check); 
    bypassA_sva:           assert property (bypassA_sva_check);      
    bypassB_sva:           assert property (bypassB_sva_check);      
    invalid_out_sva:       assert property (invalid_out_sva_check);  
    red_ora_sva:           assert property (red_ora_sva_check);      
    red_orb_sva:           assert property (red_orb_sva_check);      
    btw_or_sva:            assert property (btw_or_sva_check);       
    red_xora_sva:          assert property (red_xora_sva_check);     
    red_xorb_sva:          assert property (red_xorb_sva_check);     
    add_sva:               assert property (add_sva_check);          
    mult_sva:              assert property (mult_sva_check);         
    shift_left_sva:        assert property (shift_left_sva_check);   
    shift_right_sva:       assert property (shift_right_sva_check);  
    rotate_left_sva:       assert property (rotate_left_sva_check);  
    rotate_right_sva:      assert property (rotate_right_sva_check); 
    //? COVER PROPERTIES
    invalid_leds_sva_cp:      cover property (invalid_leds_sva_check);
    bypassA_sva_cp:           cover property (bypassA_sva_check);
    bypassB_sva_cp:           cover property (bypassB_sva_check) ;
    invalid_out_sva_cp:       cover property (invalid_out_sva_check);
    red_ora_sva_cp:           cover property (red_ora_sva_check);
    red_orb_sva_cp:           cover property (red_orb_sva_check);
    btw_or_sva_cp:            cover property (btw_or_sva_check);
    red_xora_sva_cp:          cover property (red_xora_sva_check);
    red_xorb_sva_cp:          cover property (red_xorb_sva_check);
    add_sva_cp:               cover property (add_sva_check);
    mult_sva_cp:              cover property (mult_sva_check);
    shift_left_sva_cp:        cover property (shift_left_sva_check);
    shift_right_sva_cp:       cover property (shift_right_sva_check);
    rotate_left_sva_cp:       cover property (rotate_left_sva_check);
    rotate_right_sva_cp:      cover property (rotate_right_sva_check);

endmodule