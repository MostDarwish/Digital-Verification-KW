module pencoder_sva(
    input logic clk,
    input logic rst,
    input logic [3:0] D,
    input logic [1:0] Y,
    input logic valid
);
    //? PROPERTIES
    property reset_sva_prop;
        @(posedge clk) rst |=> $past(Y) == 0 && $past(valid) == 0;
    endproperty
    property D0_sva_prop;
        @(posedge clk) disable iff(rst) D == 4'b1000 |=> $past(Y) == 0;
    endproperty
    property D1_sva_prop;
        @(posedge clk) disable iff(rst) !D[0] && !D[1] && D[2] |=> $past(Y) == 1;
    endproperty
    property D2_sva_prop;
        @(posedge clk) disable iff(rst) !D[0] && D[1] |=> $past(Y) == 2;
    endproperty
    property D3_sva_prop;
        @(posedge clk) disable iff(rst) D[0] |=> $past(Y) == 3;
    endproperty
    property not_valid_sva_prop;
        @(posedge clk) disable iff(rst) ~|D |=> $past(valid) == 0;
    endproperty
    property valid_sva_prop;
        @(posedge clk) disable iff(rst)  |D |=> $past(valid) == 1;
    endproperty
    //? ASSERTIONS
    reset_sva:     assert property (reset_sva_prop);
    D0_sva:        assert property (D0_sva_prop);
    D1_sva:        assert property (D1_sva_prop) ;
    D2_sva:        assert property (D2_sva_prop);
    D3_sva:        assert property (D2_sva_prop);
    not_valid_sva: assert property (not_valid_sva_prop);
    valid_sva:     assert property (valid_sva_prop);
    //? COVER PROPERTIES
    reset_sva_cp:     cover property (reset_sva_prop);
    D0_sva_cp:        cover property (D0_sva_prop);
    D1_sva_cp:        cover property (D1_sva_prop) ;
    D2_sva_cp:        cover property (D2_sva_prop);
    D3_sva_cp:        cover property (D3_sva_prop);
    not_valid_sva_cp: cover property (not_valid_sva_prop);
    valid_sva_cp:     cover property (valid_sva_prop);
endmodule