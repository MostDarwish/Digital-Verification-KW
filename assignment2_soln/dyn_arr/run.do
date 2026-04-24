vlib work
vlog dyn_arr.sv  +cover -covercells
vsim -voptargs=+acc work.dyn_arr -cover
#coverage save ALU_tb.ucdb -onexit -du ALU_4_bit
#do wave.do
#log -r /*
run -all
#quit -sim
#vcover report ALU_tb.ucdb -details -annotate -all -output cover_rpt.txt 