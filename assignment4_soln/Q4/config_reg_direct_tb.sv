module config_reg_direct_tb ();
  //? local parameters
  localparam CLK_CYCLE = 20;
  //? Interface signals
  bit clk;
  logic reset;
  logic write;
  logic [15:0] data_in;
  logic [15:0] data_out;
  typedef enum logic [2:0] {
    adc0_reg,
    adc1_reg,
    temp_sensor0_reg,
    temp_sensor1_reg,
    analog_test,
    digital_test,
    amp_gain,
    digital_config
  } config_reg_e;
  config_reg_e reg_addr;
  //? Variables
  int error_count, correct_count;
  logic [15:0] reset_assoc[config_reg_e];
  logic [15:0] golden_reg [config_reg_e];
  //? DUT instantiation
  config_reg DUT (
      .clk(clk),
      .reset(reset),
      .write(write),
      .data_in(data_in),
      .address(reg_addr),
      .data_out(data_out)
  );
  //? CLK generation
  always #(CLK_CYCLE / 2) clk = ~clk;
  //? assign default reset values
  initial begin
    reset_assoc[adc0_reg]         = 16'hFFFF;
    reset_assoc[adc1_reg]         = 0;
    reset_assoc[temp_sensor0_reg] = 0;
    reset_assoc[temp_sensor1_reg] = 0;
    reset_assoc[analog_test]      = 16'hABCD;
    reset_assoc[digital_test]     = 0;
    reset_assoc[amp_gain]         = 0;
    reset_assoc[digital_config]   = 1;
  end
  //? Driver block
  initial begin
    //* initialization
    reset = 0;
    write = 0;
    data_in = 0;
    reg_addr = adc0_reg;
    #CLK_CYCLE;
    //! analog_test register reset bug
    $display("RESET PHASE");
    assert_reset();


    //! adc0_reg test bug most bit stucks at 1
    @(negedge clk);
    $display("adc0_reg BUG");
    write = 1;
    data_in = 0;
    reg_addr = adc0_reg;
    golden_reg[reg_addr] = data_in;
    @(negedge clk);
    check_result(reg_addr, golden_reg);


    //! adc1_reg test bug least 8-bits swapped with most 8-bits
    $display("adc1_reg BUG");
    data_in = 16'hFF00;
    reg_addr = adc1_reg;
    golden_reg[reg_addr] = data_in;
    @(negedge clk);
    check_result(reg_addr, golden_reg);


    //! temp_sensor0_reg test bug store data_in after shift left by 1-bit
    $display("temp_sensor0_reg BUG");
    data_in = 1;
    reg_addr = temp_sensor0_reg;
    golden_reg[reg_addr] = data_in;
    @(negedge clk);
    check_result(reg_addr, golden_reg);


    //! digital_test & amp_gain registers test bug each one stores the value that should be written to the other
    $display("digital_test BUG");
    data_in = 16'hAAAA;
    reg_addr = digital_test;
    golden_reg[reg_addr] = data_in;
    @(negedge clk);
    data_in = 16'hFFFF;
    reg_addr = amp_gain;
    golden_reg[reg_addr] = data_in;
    @(negedge clk);
    check_result(reg_addr, golden_reg);

    
    //! digital_config register test bug most bit stucks at 0
    $display("digital_config BUG");
    data_in = 16'hFFFF;
    reg_addr = digital_config;
    golden_reg[reg_addr] = data_in;
    @(negedge clk);
    check_result(reg_addr, golden_reg);

    $display("error_counts = %0d, correct_counts = %0d", error_count, correct_count);
    $stop;
  end
  //? TASKS
  task assert_reset();
    reset = 1;
    @(negedge clk);
    check_result(reg_addr, reset_assoc);
    reset = 0;
  endtask

  task automatic check_result(config_reg_e reg_address, ref logic [15:0] gold_reg[config_reg_e]);
    reg_addr = reg_addr.first;
    for (int i = 0; i < reg_addr.num; i++) begin
      #(CLK_CYCLE / 20);
      if (data_out == gold_reg[reg_addr]) correct_count++;
      else begin
        error_count++;
        $display("\txxxx ERROR at time %0t: the actual output result is not matching the expected result xxxx",$time);
        $display("\taddr=%s(%0d) actual_data_out=%h expected_data_out=%h\n", reg_addr.name(), int'(reg_addr), data_out, gold_reg[reg_addr]);
      end
      golden_reg[reg_addr] = data_out;
	  reg_addr = reg_addr.next;
    end
    reg_addr = reg_address;
  endtask

endmodule
