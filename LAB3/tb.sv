import testing_pkg::*;

module tb();
    Transaction tr = new;
    byte operand1, operand2, out;
    opcode_e opcode;
    bit clk, rst;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
            tr.clk = clk;
        end
    end

    //<DUT Instantiation>
    alu_seq DUT(operand1, operand2, clk, rst, opcode, out);

    initial begin
        rst = 1;
        @(negedge clk);
        rst = 0;

        repeat(32) begin // Run a few cycles
            assert(tr.randomize); // Create a transaction
            operand1 = tr.operand1;
            operand2 = tr.operand2;
            opcode = tr.opcode;
            @(negedge clk);
        end

        $stop();
    end // initial begin

endmodule