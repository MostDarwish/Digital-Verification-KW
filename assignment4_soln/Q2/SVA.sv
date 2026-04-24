module general_sva(clk, a, b, c, d, y, valid);
    input bit clk, a, b, c, d, y, valid;

    assertion_1: assert property (@(posedge clk) a |-> ##2 b);
    assertion_2: assert property (@(posedge clk) a&&b |-> ##[1:3] c);
    
    sequence s11b;
        ##2 (!b);
    endsequence
    
    property prop1;
        @(posedge clk) $one_hot(y);
    endproperty

    property prop2;
        @(posedge clk) d==0 |=> !valid;
    endproperty
    
endmodule