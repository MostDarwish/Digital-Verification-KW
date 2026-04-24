module dyn_arr();
    int dyn_arr1 [] = new[5];
    int dyn_arr2 [] = '{9,1,8,3,4,4};

    initial begin
        foreach (dyn_arr1[i]) begin
            dyn_arr1[i] = i;
        end
        $display("dyn_arr1=%p, size=%0d", dyn_arr1, dyn_arr1.size());
        dyn_arr1.delete();
        dyn_arr2.reverse();
        $display("reversed_dyn_arr2=%p", dyn_arr2);
        dyn_arr2.sort();
        $display("sorted_dyn_arr2=%p", dyn_arr2);
        dyn_arr2.rsort();
        $display("reversesort_dyn_arr2=%p", dyn_arr2);
        dyn_arr2.shuffle();
        $display("shuffled_dyn_arr2=%p", dyn_arr2);
        $stop;
    end
endmodule