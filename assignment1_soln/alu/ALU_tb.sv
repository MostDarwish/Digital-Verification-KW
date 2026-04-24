module ALU_tb ();
  //? local parameters
  localparam MAXPOS = 7;
  localparam MAXNEG = -8;
  localparam Add = 2'b00;
  localparam Sub = 2'b01;
  localparam Not_A = 2'b10;
  localparam ReductionOR_B = 2'b11;
  localparam CLK_CYCLE = 2;
  //? Interface signals
  logic reset, clk;
  logic signed [3:0] A, B;
  logic signed [4:0] C;
  logic [1:0] opcode;
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
    //! ALU_1 test
    clk = 0;
    reset = 0;
    A = $random;
    B = $random;
    opcode = $random;
    #(CLK_CYCLE) assert_reset();
    //! ALU_2 test
    //op-code iterator
    for (int i = 0; i < 2; i++) begin
      if (i == 0) opcode = Add;
      else opcode = Sub;
      //input A iterator
      for (int j = 0; j < 3; j++) begin
        if (j == 0) A = 0;
        else if (j == 1) A = MAXPOS;
        else A = MAXNEG;
        //input B iterator
        for (int k = 0; k < 3; k++) begin
          if (k == 0) B = 0;
          else if (k == 1) B = MAXPOS;
          else B = MAXNEG;
          if (opcode == Add) check_result(A + B);
          else check_result(A - B);
        end
      end
    end
    //! ALU_3 test
    B = $random;
    A = 4'b1111;
    opcode = Not_A;
    check_result(~A);
    A = 4'b0000;
    check_result(~A);
    A = 4'b0001;
    check_result(~A);
    A = 4'b0010;
    check_result(~A);
    A = 4'b0100;
    check_result(~A);
    A = 4'b1000;
    check_result(~A);
		//! ALU_4 test
		A = $random;
		B = 4'b1111;
		opcode = ReductionOR_B;
		check_result(|B);
		B = 4'b0000;
		check_result(|B);
		B = 4'b0001;
		check_result(|B);
		B = 4'b0010;
		check_result(|B);
		B = 4'b0100;
		check_result(|B);
		B = 4'b1000;
		check_result(|B);
		//! ALU_5 test
		for(int i=0; i<100; i++)begin
			A = $random;
			B = $random;
			opcode = $random;
			if(i<10) begin
				reset = 1;
				check_result(0);
			end
			else begin
				reset = 0;
				if(opcode == Add) check_result(A+B);
				else if(opcode == Sub) check_result(A-B);
				else if(opcode == Not_A) check_result(~A);
				else if(opcode == ReductionOR_B) check_result(|B);
			end
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

  task check_result(input [4:0] expected_C);
    #CLK_CYCLE;
    if (expected_C == C) correct_count++;
    else begin
      error_count++;
      $display("xxxx ERROR: the actual output result is not matching the expected result xxxx");
      $display("A=%0b ,B=%0b, C_exp=%0b, C_actual=%0b, opcode=%0b, reset=%0b", A, B, expected_C, C, opcode, reset);
    end
  endtask

endmodule
