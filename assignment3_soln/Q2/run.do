vlib work
vlog COUNTER_PACKAGE.sv counter.v counter_tb.sv +cover -covercells
vsim -voptargs=+acc work.counter_tb -cover
coverage save counter.ucdb -onexit
log -r /*
run -all
quit -sim
vcover report counter.ucdb -du=counter -details -annotate -all -output code_cover_rpt.txt
vcover report counter.ucdb -package=COUNTER_PACKAGE -cvg -details -annotate -all -output fun_cover_rpt.txt