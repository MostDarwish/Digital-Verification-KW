package shared_pkg;
  parameter INPUT_PRIORITY = "A";
  parameter FULL_ADDER = "ON";
  parameter MAXPOS = 3'b011;
  parameter MAXNEG = 3'b100;
  parameter ZERO = 3'b000;
  typedef enum logic [2:0] {
    OR,
    XOR,
    ADD,
    MULT,
    SHIFT,
    ROTATE,
    INVALID_6,
    INVALID_7
  } opcode_e;
  typedef enum logic {
    SHFT,
    ROT
  } mode_e;
  typedef enum logic {
    RIGHT,
    LEFT
  } direction_e;
endpackage
