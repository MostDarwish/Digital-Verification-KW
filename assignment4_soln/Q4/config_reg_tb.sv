module config_reg_tb ();
  //? local parameters
  localparam MAX = 16'hffff;
  localparam ZERO = 0;
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
    
    //! REG_1 TEST
    assert_reset();


    //! REG_2 TEST
    $display("\n******write data when write signal is disabled******");
    @(negedge clk);
    data_in = 16'hAAAA;
    reg_addr = reg_addr.first;
    for(int i=0; i<reg_addr.num; i++) begin
      @(negedge clk);
      check_result(reg_addr, golden_reg);
      reg_addr = reg_addr.next;
    end


    //! REG_3 TEST
    $display("\n*******check that write operation is completely sequential not compinational********");
    @(negedge clk);
    //*check if any register sampled the input direct before the next positive edge
    write = 1;
    check_result(reg_addr, golden_reg);


    //! REG_4 TEST
    $display("\n*******check normal write operations with different input values********");
    //* fill regfile with zeros
    $display("\n----fill regfile with zeros----");
    fill(reg_addr, data_in, 0);
    check_result(reg_addr, golden_reg);


    //* check writing all ones in each reg while other regs are zeros
    $display("\n----writing all ones in each register while reseting others----");
    data_in = 16'hFFFF;
    reg_addr = reg_addr.first;
    for(int i=0; i<reg_addr.num; i++) begin
      $display("16'hFFFF written in address: %s while other addresses are zero", reg_addr.name());
      golden_reg[reg_addr] = data_in;
      @(negedge clk);
      check_result(reg_addr, golden_reg);
      reg_addr = reg_addr.next;
      fill(reg_addr, data_in, 0);
    end


    //* check writing walking ones in each register while other regs are zero
    $display("\n----writing walking ones in each register----");
    reg_addr = reg_addr.first;
    for(int i=0; i<reg_addr.num; i++) begin
      data_in = 16'h0001;
      for(int j=0; j<16; j++) begin
        golden_reg[reg_addr] = data_in;
        @(negedge clk);
        $display("data_in = %b written in address: %s while other addresses are zero", data_in ,reg_addr.name());
        check_result(reg_addr, golden_reg);
        fill(reg_addr, data_in, 0);
        data_in = data_in << 1;
      end
      reg_addr = reg_addr.next;
    end


    //* randomization
    $display("\n******randomization phase******");
    reg_addr = reg_addr.first;
    for(int i=0; i<reg_addr.num; i++) begin
      for(int j=0; j<100; j++) begin
        data_in = $random;
        write = $random;
        if(write) golden_reg[reg_addr] = data_in;
        @(negedge clk);
        if (write) $display("data_in = %b not written in address: %s as write is disabled", data_in, reg_addr.name());
        else $display("data_in = %b written in address: %s while other addresses are zero", data_in ,reg_addr.name());
        check_result(reg_addr, golden_reg);
      end
      reg_addr = reg_addr.next;
    end


    $display("error_counts = %0d, correct_counts = %0d", error_count, correct_count);
    $stop;
  end
  //? TASKS
  task assert_reset();
    reset = 1;
    @(negedge clk);
    $display("\n*****RESET PHASE*****");
    check_result(reg_addr, reset_assoc);
    reset = 0;
  endtask

  task fill(config_reg_e reg_address, logic [15:0] data_input, fill_value);
    data_in = fill_value;
    reg_addr = reg_addr.first;
    for(int i=0; i<reg_addr.num; i++) begin
      @(negedge clk);
      golden_reg[reg_addr] = data_in;
      reg_addr = reg_addr.next;
    end
    reg_addr = reg_address;
    data_in = data_input;
  endtask

  task automatic check_result(config_reg_e reg_address, ref logic [15:0] gold_reg[config_reg_e]);
    reg_addr = reg_addr.first;

    for (int i = 0; i < reg_addr.num; i++) begin
      #(CLK_CYCLE / 20);

      if (data_out == gold_reg[reg_addr]) correct_count++;
      else begin
        error_count++;
        $display(
            "\txxxx ERROR at time %0t: the actual output result is not matching the expected result xxxx",
            $time);
        $display("\taddr=%s(%0d) actual_data_out=%b expected_data_out=%b\n", reg_addr.name(),
                 int'(reg_addr), data_out, gold_reg[reg_addr]);
      end

      golden_reg[reg_addr] = data_out;
			reg_addr = reg_addr.next;
    end
    reg_addr = reg_address;
  endtask

endmodule
