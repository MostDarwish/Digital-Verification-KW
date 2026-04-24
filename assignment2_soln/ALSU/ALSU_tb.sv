import ALSU_PACKAGE::*;
module ALSU_tb ();
  //? local parameters
  localparam CLK_CYCLE = 2;
  //? Variables
  int error_count, correct_count;
  //? interface signals
  logic clk;
  logic rst;
  logic cin;
  logic serial_in;
  logic direction;
  logic red_op_A;
  logic red_op_B;
  logic bypass_A;
  logic bypass_B;
  logic signed [2:0] A;
  logic signed [2:0] B;
  logic [5:0] out;
  logic [15:0] leds;
  opcode_e opcode;
  //? golden model outputs
  logic signed [5:0] out_g;
  logic [15:0] leds_g;
  //? input registers
  logic cin_reg;
  logic serial_in_reg;
  logic direction_reg;
  logic red_op_A_reg;
  logic red_op_B_reg;
  logic bypass_A_reg;
  logic bypass_B_reg;
  logic signed [2:0] A_reg;
  logic signed [2:0] B_reg;
  opcode_e opcode_reg;
  //? class object
  ALSU_Rand_Var ALSU_obj;
  //? DUT instantiation
  ALSU #(
      .INPUT_PRIORITY(INPUT_PRIORITY),
      .FULL_ADDER(FULL_ADDER)
  ) ALSU_DUT (
      .clk(clk),
      .rst(rst),
      .cin(cin),
      .serial_in(serial_in),
      .direction(direction),
      .red_op_A(red_op_A),
      .red_op_B(red_op_B),
      .bypass_A(bypass_A),
      .bypass_B(bypass_B),
      .A(A),
      .B(B),
      .opcode(opcode),
      .out(out),
      .leds(leds)
  );
  //? CLK generation
  always #(CLK_CYCLE / 2) clk = ~clk;
  //? Driver block
  initial begin
    //*initialization
    ALSU_obj = new();
    clk = 0;
    assign_class_properties();
    //! ALSU_1 TEST
    assert_reset();
    $display("ALSU_1 TEST time = %0t", $time);
    //! ALSU_2 TEST
    ALSU_obj.opcode = ADD;
    for (int i = 0; i < 20; i++) begin
      assert (ALSU_obj.randomize(A, B, cin));
      run_test();
    end
    $display("ALSU_2 TEST time = %0t", $time);
    //! ALSU_3 TEST
    ALSU_obj.opcode = MULT;
    for (int i = 0; i < 20; i++) begin
      assert (ALSU_obj.randomize(A, B));
      run_test();
    end
    $display("ALSU_3 TEST time = %0t", $time);
    //! ALSU_4 TEST
    for (int i = 0; i < 20; i++) begin
      ALSU_obj.opcode = OR;
      assert (ALSU_obj.randomize(A, B));
      run_test();
      ALSU_obj.opcode = XOR;
      run_test();
    end
    $display("ALSU_4 TEST time = %0t", $time);
    //! ALSU_5 TEST
    ALSU_obj.opcode = SHIFT;
    for (int i = 0; i < 20; i++) begin
      assert (ALSU_obj.randomize(serial_in, direction));
      run_test();
    end
    $display("ALSU_5 TEST time = %0t", $time);
    //! ALSU_6 TEST
    // AN ADD OPERATION TO MAKE SURE THAT OUTPUT HAS ONLY ONE BIT=1 TO MAKE ROTATION EASY TO APPEAR
    ALSU_obj.A = 1;
    ALSU_obj.B = 0;
    ALSU_obj.opcode = ADD;
    run_test();
    ALSU_obj.opcode = ROTATE;
    for (int i = 0; i < 20; i++) begin
      assert (ALSU_obj.randomize(direction));
      run_test();
    end
    $display("ALSU_6 TEST time = %0t", $time);
    //! ALSU_7 TEST
    for (int j = 0; j < 2; j++) begin
      if (j == 0) ALSU_obj.opcode = OR;
      else ALSU_obj.opcode = XOR;
      for (int i = 0; i < 30; i++) begin
        if (i < 10) begin
          ALSU_obj.red_op_A = 1;
          ALSU_obj.red_op_B = 0;
        end else if (i < 20) begin
          ALSU_obj.red_op_A = 0;
          ALSU_obj.red_op_B = 1;
        end else begin
          ALSU_obj.red_op_A = 1;
          ALSU_obj.red_op_B = 1;
        end
        assert (ALSU_obj.randomize(A, B));
        run_test();
      end
    end
    $display("ALSU_7 TEST time = %0t", $time);
    //! ALSU_8 TEST
    for (int i = 0; i < 30; i++) begin
      if (i < 10) begin
        ALSU_obj.bypass_A = 1;
        ALSU_obj.bypass_B = 0;
      end else if (i < 20) begin
        ALSU_obj.bypass_A = 0;
        ALSU_obj.bypass_B = 1;
      end else begin
        ALSU_obj.bypass_A = 1;
        ALSU_obj.bypass_B = 1;
      end
      assert (ALSU_obj.randomize(A, B, red_op_A, red_op_B, opcode));
      run_test();
    end
    $display("ALSU_8 TEST time = %0t", $time);
    //! ALSU_9 TEST
    ALSU_obj.bypass_A = 0;
    ALSU_obj.bypass_B = 0;
    ALSU_obj.opcode   = INVALID_6;
    ALSU_obj.red_op_A = 1;
    run_test();
    ALSU_obj.opcode = ADD;
    run_test();
    for(int i =0; i<5;i++)begin
        ALSU_obj.opcode   = INVALID_7;
        ALSU_obj.red_op_A = 0;
        ALSU_obj.red_op_B = 0;
        run_test();
    end
    $display("ALSU_9 TEST time = %0t", $time);
    //! ALU_10 TEST
    for (int i = 0; i < 100; i++) begin
      assert (ALSU_obj.randomize());
      run_test();
    end
    $display("ALSU_10 TEST time = %0t", $time);
    $display("error_counts = %0d, correct_counts = %0d", error_count, correct_count);
    $stop;
  end
  //? TASKS
  task assert_reset();
    rst = 1;
    #CLK_CYCLE;
    check_result(out_g, leds_g);
    rst = 0;
endtask

task automatic check_result(input [5:0] out_exp, input [15:0] leds_exp);
if (out_exp == out && leds_exp == leds) correct_count++;
else begin
    error_count++;
      $display(
          "xxxx ERROR at time %0t: the actual output result is not matching the expected result xxxx",
            $time);
            $display("out=%0b ,out_exp=%0b, leds=%0h, leds_exp=%0h", out, out_exp, leds, leds_exp);
        end
    endtask
    
    task assign_class_properties();
      rst = ALSU_obj.rst;
      A = ALSU_obj.A;
      B = ALSU_obj.B;
      cin = ALSU_obj.cin;
      opcode = ALSU_obj.opcode;
      serial_in = ALSU_obj.serial_in;
      direction = ALSU_obj.direction;
      red_op_A = ALSU_obj.red_op_A;
      red_op_B = ALSU_obj.red_op_B;
      bypass_A = ALSU_obj.bypass_A;
      bypass_B = ALSU_obj.bypass_B;
    endtask
    
    task run_test();
      assign_class_properties();
      #(2 * CLK_CYCLE);
      check_result(out_g, leds_g);
    endtask
  //*GOLDEN MODEL
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      cin_reg <= 0;
      red_op_B_reg <= 0;
      red_op_A_reg <= 0;
      bypass_B_reg <= 0;
      bypass_A_reg <= 0;
      direction_reg <= 0;
      serial_in_reg <= 0;
      opcode_reg <= ADD;
      A_reg <= 0;
      B_reg <= 0;
    end else begin
      cin_reg <= cin;
      red_op_B_reg <= red_op_B;
      red_op_A_reg <= red_op_A;
      bypass_B_reg <= bypass_B;
      bypass_A_reg <= bypass_A;
      direction_reg <= direction;
      serial_in_reg <= serial_in;
      opcode_reg <= opcode;
      A_reg <= A;
      B_reg <= B;
    end
  end
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      out_g  <= 0;
      leds_g <= 0;
    end else if (bypass_A_reg || bypass_B_reg) begin
      if (INPUT_PRIORITY == "A") begin
        if (bypass_A_reg) begin
          out_g  <= A_reg;
          leds_g <= 0;
        end else begin
          out_g  <= B_reg;
          leds_g <= 0;
        end
      end else begin
        if (bypass_B_reg) begin
          out_g  <= B_reg;
          leds_g <= 0;
        end else begin
          out_g  <= A_reg;
          leds_g <= 0;
        end
      end
    end else begin
      case (opcode_reg)
        ADD: begin
          if (red_op_A_reg == 0 && red_op_B_reg == 0) begin
            if (FULL_ADDER == "ON") begin
              out_g  <= {{3{A_reg[2]}}, A_reg} + {{3{B_reg[2]}}, B_reg} + cin_reg;
              leds_g <= 0;
            end else begin
              out_g  <= {{3{A_reg[2]}}, A_reg} + {{3{B_reg[2]}}, B_reg};
              leds_g <= 0;
            end
          end else begin
            out_g  <= 0;
            leds_g <= ~leds_g;
          end
        end
        MULT: begin
          if (red_op_A_reg == 0 && red_op_B_reg == 0) begin
            out_g  <= A_reg * B_reg;
            leds_g <= 0;
          end else begin
            out_g  <= 0;
            leds_g <= ~leds_g;
          end
        end
        SHIFT: begin
          if (red_op_A_reg == 0 && red_op_B_reg == 0) begin
            if (direction_reg) out_g <= {out_g[4:0], serial_in_reg};
            else out_g <= {serial_in_reg, out_g[5:1]};
            leds_g <= 0;
          end else begin
            out_g  <= 0;
            leds_g <= ~leds_g;
          end
        end
        ROTATE: begin
          if (red_op_A_reg == 0 && red_op_B_reg == 0) begin
            if (direction_reg) out_g <= {out_g[4:0], out_g[5]};
            else out_g <= {out_g[0], out_g[5:1]};
            leds_g <= 0;
          end else begin
            out_g  <= 0;
            leds_g <= ~leds_g;
          end
        end
        OR: begin
          if (red_op_A_reg || red_op_B_reg) begin
            if (INPUT_PRIORITY == "A") begin
              if (red_op_A_reg) out_g <= |A_reg;
              else out_g <= |B_reg;
            end else begin
              if (red_op_B_reg) out_g <= |B_reg;
              else out_g <= |A_reg;
            end
          end else out_g <= A_reg | B_reg;
          leds_g <= 0;
        end
        XOR: begin
          if (red_op_A_reg || red_op_B_reg) begin
            if (INPUT_PRIORITY == "A") begin
              if (red_op_A_reg) out_g <= ^A_reg;
              else out_g <= ^B_reg;
            end else begin
              if (red_op_B_reg) out_g <= ^B_reg;
              else out_g <= ^A_reg;
            end
          end else out_g <= A_reg ^ B_reg;
          leds_g <= 0;
        end
        default: begin
          out_g  <= 0;
          leds_g <= ~leds_g;
        end
      endcase
    end
  end


endmodule
