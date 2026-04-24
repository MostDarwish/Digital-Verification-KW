module array();
    bit [11:0] my_array [4];
    initial begin
        my_array[0] = 12'h012;
        my_array[1] = 12'h345;
        my_array[2] = 12'h678;
        my_array[3] = 12'h9AB;
        //! traversing using for loop and print bits [5:4]
        $display("****traversing using for loop****");
        for(int i=0; i<$size(my_array); i++)
            $display("my_array[%0d][5:4]=%b", i, my_array[i][5:4]);
        //! traversing using foreach loop and print bits [5:4]
        $display("****traversing using foreach loop****");
        foreach (my_array[i]) begin
            $display("my_array[%0d][5:4]=%b", i, my_array[i][5:4]);            
        end
        $stop;
    end
endmodule