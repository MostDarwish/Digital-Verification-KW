////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_monitor(vending_machine_if.MONITOR v_if);
    initial begin
        $monitor("Q_in=%b, D_in=%b, rstn=%b, change=%b, dispense=%b", v_if.Q_in, v_if.D_in, v_if.rstn, v_if.change, v_if.dispense);
    end
endmodule