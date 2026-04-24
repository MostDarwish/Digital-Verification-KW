module ALU_sva(
    input logic clk,
    input logic reset,
    input logic signed [3:0] A, B,
    input logic signed [4:0] C,
    input logic [1:0] opcode
);
    localparam Add = 2'b00;
    localparam Sub = 2'b01;
    localparam Not_A = 2'b10;
    localparam ReductionOR_B = 2'b11;
    //? asynchronous reset assertion
    always_comb begin 
        if(reset) 
            arst_sva: assert final(C == 0);  
    end
    //? PROPERTIES
    property add_sva_prop;
        @(posedge clk) disable iff(reset) opcode == Add |=> C == $past(A) + $past(B);
    endproperty
    property sub_sva_prop;
        @(posedge clk) disable iff(reset) opcode == Sub |=> C == $past(A) - $past(B);
    endproperty
    property not_a_sva_prop;
        @(posedge clk) disable iff(reset) opcode == Not_A |=> C == ~$past(A);
    endproperty
    property reduction_sva_prop;
        @(posedge clk) disable iff(reset) opcode == ReductionOR_B |=> C == |$past(B);
    endproperty
    //? ASSERTIONS
    add_sva:       assert property (add_sva_prop);
    sub_sva:       assert property (sub_sva_prop);
    not_a_sva:     assert property (not_a_sva_prop) ;
    reduction_sva: assert property (reduction_sva_prop);
    //? COVER PROPERTIES
    add_sva_cp:       cover property (add_sva_prop);
    sub_sva_cp:       cover property (sub_sva_prop);
    not_a_sva_cp:     cover property (not_a_sva_prop) ;
    reduction_sva_cp: cover property (reduction_sva_prop);
endmodule