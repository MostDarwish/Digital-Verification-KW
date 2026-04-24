module Q2_sva(
    input logic clk,
    input logic request,
    input logic grant,
    input logic frame,
    input logic irdy
);
    //? PROPERTIES
    property request_sva_prop;
        @(posedge clk) $rose(request) |-> ##[2:5] $rose(grant);
    endproperty
    property grant_sva_prop;
        @(posedge clk) $rose(grant) |-> $fell(frame) && $fell(irdy);
    endproperty
    property complete_sva;
        @(posedge clk) $rose(frame) && $rose(irdy) |=> $fell(grant);
    endproperty
endmodule