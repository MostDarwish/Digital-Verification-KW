////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Shift register Interface
// 
////////////////////////////////////////////////////////////////////////////////
import shared_pkg::*;
interface shift_reg_if ();
  logic serial_in;
  direction_e direction;
  mode_e mode;
  logic [5:0] datain, dataout;
endinterface : shift_reg_if