package FIFO_scoreboard_pkg;
    import FIFO_transaction_pkg::*;
    import shared_pkg::*;
    class FIFO_scoreboard;
        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic [FIFO_WIDTH-1:0] FIFO_ref [$];
        function void check_data (FIFO_transaction F_txn);
            ref_model(F_txn);
            `ifdef FULL_DEBUG
                if (F_txn.data_out === data_out_ref) begin
                    correct_count++;
                    $display("correct output at time:%0t", $time);
                    $display("input stimulus: write_enable = %b, read_enable = %b, data_in = %0h output = %0h", F_txn.wr_en, F_txn.rd_en, F_txn.data_in, F_txn.data_out);
                    $display("expected current FIFO content:");
                    foreach (FIFO_ref[i]) begin
                        $display("FIFO[%0d] = %0h", i, FIFO_ref[i]);
                    end
                    $display("*********************************************************\n*********************************************************\n");
                end
            `else
                if (F_txn.data_out === data_out_ref) correct_count++;
            `endif
            else begin
                error_count++;
                $display("error at time:%0t, the expected output = %0h, the actual output = %0h",
                $time, data_out_ref, F_txn.data_out);
                $display("input stimulus: write_enable = %b, read_enable = %b, data_in = %0h", F_txn.wr_en, F_txn.rd_en, F_txn.data_in);
                $display("expected current FIFO content:");
                foreach (FIFO_ref[i]) begin
                    $display("FIFO[%0d] = %0h", i, FIFO_ref[i]);
                end
                $display("*********************************************************\n*********************************************************\n");
            end
        endfunction

        function void ref_model (FIFO_transaction F_txn);
            if (!F_txn.rst_n) begin
                FIFO_ref.delete();
                data_out_ref = 0;
            end

            else if(F_txn.wr_en && F_txn.rd_en && FIFO_ref.size() == FIFO_DEPTH)
                data_out_ref = FIFO_ref.pop_front();
            
            else if(F_txn.wr_en && F_txn.rd_en && FIFO_ref.size() == 0)
                FIFO_ref.push_back(F_txn.data_in);
            
            else begin
                if(F_txn.wr_en && FIFO_ref.size() < FIFO_DEPTH) FIFO_ref.push_back(F_txn.data_in);
                if(F_txn.rd_en && FIFO_ref.size() > 0) data_out_ref = FIFO_ref.pop_front();
            end
        endfunction
    endclass
endpackage