////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_top();
    bit clk;
    always #50 clk = ~clk;
    vending_machine_if v_if(clk);
    vending_machine DUT (v_if);
    vending_machine_tb TB (v_if);
    vending_machine_monitor MONITOR (v_if);
    bind vending_machine vending_machine_sva vending_sva_inst(v_if);
endmodule
