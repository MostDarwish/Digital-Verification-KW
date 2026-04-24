import ALU_PACKAGE::*;
module ALU_tb ();
  //? local parameters
  localparam CLK_CYCLE = 2;
  //? class object handler creation
  ALU_R alu_obj;
  //? Interface signals
  logic reset, clk;
  logic signed [3:0] A, B;
  logic signed [4:0] C;
  opcode_e opcode;
  //? Variables
  int error_count, correct_count;
  //? DUT instantiation
  ALU_4_bit DUT_ALU (
      .clk(clk),
      .reset(reset),
      .Opcode(opcode),
      .A(A),
      .B(B),
      .C(C)
  );
  //? CLK generation
  always #(CLK_CYCLE / 2) clk = ~clk;
  //? Driver block
  initial begin
    //* initialization
    clk = 0;
    alu_obj = new();
    #(CLK_CYCLE) assert_reset();
    //! ALU Randomization test
    for (int i=0; i<100; i++) begin
      alu_obj.randomize();
      A = alu_obj.A;
      B = alu_obj.B;
      reset = alu_obj.reset;
      opcode = alu_obj.opcode;
      golden_model();      
    end
		$display("error_counts = %0d, correct_counts = %0d", error_count, correct_count);
		$stop;
  end
  //? TASKS
  task assert_reset();
    reset = 1;
    check_result(0);
    reset = 0;
  endtask

  task check_result(input logic signed [4:0] expected_C);
    #CLK_CYCLE;
    if (expected_C == C) correct_count++;
    else begin
      error_count++;
      $display("xxxx ERROR at time %0t: the actual output result is not matching the expected result xxxx", $time);
      $display("A=%0b ,B=%0b, C_exp=%0b, C_actual=%0b, opcode=%0b, reset=%0b", A, B, expected_C, C, opcode, reset);
    end
  endtask

  task golden_model();
    logic signed [4:0] c_exp;
    if (reset) c_exp = 0;
    else begin
      case (opcode)
        Add: c_exp = A + B; 
        Sub: c_exp = A - B;
        Not_A: c_exp = ~A;
        ReductionOR_B: c_exp = |B;
        default: c_exp = 0;
      endcase
    end
    check_result(c_exp);
  endtask
endmodule
