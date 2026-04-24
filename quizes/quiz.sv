package quiz_4;
    class quiz;
        rand byte q [$];

        constraint c1{
            q.size() inside {[10:20]};
            q.sum() == 7; 
        }
    endclass
endpackage