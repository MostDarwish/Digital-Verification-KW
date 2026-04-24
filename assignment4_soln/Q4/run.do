vlib work
vlog config_reg_buggy_questa.svp config_reg_direct_tb.sv +cover -covercells
vsim -voptargs=+acc work.config_reg_direct_tb -cover
coverage save config_reg.ucdb -onexit -du config_reg
#do wave.do
log -r /*
run -all
#quit -sim
#vcover report counter.ucdb -details -annotate -all -output cover_rpt.txt