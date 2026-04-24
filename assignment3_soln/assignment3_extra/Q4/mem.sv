module mem();

    typedef logic [19:0] addr_t;
    logic [23:0] memory [addr_t];

    initial begin
        memory [0] = 24'hA50400;
        memory [20'h400] = 24'h123456;
        memory [20'h401] = 24'h789ABC;
        memory [20'hFFFFF] = 24'h0F1E2D;
        // Print number of elements
        $display("Number of elements = %0d", memory.num());

        // Iterate and print all elements
        foreach (memory[i]) begin
            $display("memory[%0h] = %0h", i, memory[i]);
        end
        $stop;
    end

endmodule