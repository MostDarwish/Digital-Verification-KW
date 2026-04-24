import FSM_PACKAGE::*;
module FSM_tb ();
  //? local parameters
  localparam CLK_CYCLE = 2;
  //? class object handler creation
  fsm_transaction fsm_obj;
  //? Interface signals
  logic rst, clk, x, y;
  logic [9:0] users_count;
  //? Variables
  int error_count, correct_count;
  //? DUT instantiation
  FSM_010 DUT_FSM (
      .clk(clk),
      .rst(rst),
      .x(x),
      .y(y),
      .users_count(users_count)
  );
  //? CLK generation
  initial begin
    clk = 0;
    forever begin
      #1 clk = ~clk;
      fsm_obj.clk = clk;
    end
  end
  //? Driver block
  initial begin
    //* initialization
    clk = 0;
    fsm_obj = new();
    //* reset test
    fsm_obj.rst = 1;
    rst = fsm_obj.rst;
    check_result();
    //* randomization test
    for (int i = 0; i < 100; i++) begin
      assert(fsm_obj.randomize());
      x   = fsm_obj.x;
      rst = fsm_obj.rst;
      check_result();
    end
    $display("error_counts = %0d, correct_counts = %0d", error_count, correct_count);
    $stop;
  end
  //? TASKS
  task check_result();
    logic y_exp;
    logic [9:0] users_count_exp;
    golden_model(y_exp, users_count_exp);
    #CLK_CYCLE;
    if (y_exp == y && users_count_exp == users_count) correct_count++;
    else begin
      error_count++;
      $display(
          "xxxx ERROR at time %0t: the actual output result is not matching the expected result xxxx",
          $time);
      $display("y=%b ,users_count=%0d, y_exp=%b, users_count_exp=%0d", y, users_count, y_exp,
               users_count_exp);
    end
  endtask

  task golden_model(output y_exp, output [9:0] count_exp);
    if (rst) begin
      fsm_obj.y_exp = 0;
      fsm_obj.user_count_exp = 0;
      fsm_obj.state = IDLE;
    end else begin
      case (fsm_obj.state)
        IDLE: if (x) fsm_obj.state = IDLE; else fsm_obj.state = ZERO;
        ZERO: if (x) fsm_obj.state = ONE; else fsm_obj.state = ZERO;
        ONE: if (x) fsm_obj.state = IDLE; else fsm_obj.state = STORE;
        STORE: begin
          fsm_obj.user_count_exp++;
          if (x) fsm_obj.state = IDLE; else fsm_obj.state = ZERO;
        end
        default: fsm_obj.state = IDLE;
      endcase
      if(fsm_obj.state == STORE) fsm_obj.y_exp = 1; else fsm_obj.y_exp = 0;
    end
    y_exp = fsm_obj.y_exp;
    count_exp = fsm_obj.user_count_exp;
  endtask
endmodule
