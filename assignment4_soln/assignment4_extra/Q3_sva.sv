module Q3_sva(
    input logic clk,
    input logic get_data
);
    localparam IDLE = 0;
    localparam GEN_BLK_ADDR = 1;
    localparam WAITO = 2;
    logic cs;
    //? PROPERTIES
    always_comb begin
        assert ($onehot(cs));
    end
    property state_transition;
        @(posedge clk) cs==IDLE && $rose(get_data) |=> cs==GEN_BLK_ADDR ##64 cs==WAITO;
    endproperty
endmodule