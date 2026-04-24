////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_sva(vending_machine_if.MONITOR v_if);
    //? First Assertion: At each positive edge of the clock, if the D_in is high then at the same clock cycle, the dispense and the change outputs are high
    assert property (@(posedge v_if.clk) v_if.D_in |-> (v_if.change && v_if.dispense));
    //? Second Assertion: At each positive edge of the clock, If there is a rising edge for the input Q_in then after 2 clock cycles the dispense output is high
    assert property (@(posedge v_if.clk) $rose(v_if.Q_in) |-> ##2 v_if.dispense);
    //? Third Assertion: At each positive edge of the clock, if the Q_in is high then at the same clock cycle, the change must be low
    assert property (@(posedge v_if.clk) v_if.Q_in |-> !v_if.change);

endmodule