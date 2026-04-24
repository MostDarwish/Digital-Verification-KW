////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
interface vending_machine_if(clk);
    localparam WAIT = 0;
    localparam Q_25 = 1;
    localparam Q_50 = 2;
    input bit clk;
    logic Q_in, D_in, rstn, dispense, change;

    modport DUT (input Q_in, D_in, rstn, clk,
                 output change, dispense);

    modport TEST (output Q_in, D_in, rstn,
                  input change, dispense, clk);

    modport MONITOR (input Q_in, D_in, clk, rstn, change, dispense);

endinterface 