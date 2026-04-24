module ALU_tb (
  //? Interface signals
  input logic clk,
  output logic reset,
  output logic signed [3:0] A, B,
  input logic signed [4:0] C,
  output logic [1:0] opcode
);
  //? parameters
  localparam MAXPOS = 7;
  localparam MAXNEG = -8;
  localparam Add = 2'b00;
  localparam Sub = 2'b01;
  localparam Not_A = 2'b10;
  localparam ReductionOR_B = 2'b11;
  localparam CLK_CYCLE = 2;
  //? Driver block
  initial begin
    //! ALU_1 test
    reset = 0;
    A = $random;
    B = $random;
    opcode = $random;
    #(CLK_CYCLE) 
    reset = 1;
    #CLK_CYCLE;
    reset = 0;
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
          #CLK_CYCLE;
        end
      end
    end
    //! ALU_3 test
    B = $random;
    A = 4'b1111;
    opcode = Not_A;
    #CLK_CYCLE
    A = 4'b0000;
    #CLK_CYCLE
    A = 4'b0001;
    #CLK_CYCLE
    A = 4'b0010;
    #CLK_CYCLE
    A = 4'b0100;
    #CLK_CYCLE
    A = 4'b1000;
    #CLK_CYCLE
		//! ALU_4 test
		A = $random;
		B = 4'b1111;
		opcode = ReductionOR_B;
		#CLK_CYCLE
		B = 4'b0000;
		#CLK_CYCLE
		B = 4'b0001;
		#CLK_CYCLE
		B = 4'b0010;
		#CLK_CYCLE
		B = 4'b0100;
		#CLK_CYCLE
		B = 4'b1000;
		#CLK_CYCLE
		//! ALU_5 test
		for(int i=0; i<100; i++)begin
			A = $random;
			B = $random;
			opcode = $random;
			if(i<10) begin
				reset = 1;
				#CLK_CYCLE;
			end
			else reset = 0;
		end
		$stop;
  end
endmodule
