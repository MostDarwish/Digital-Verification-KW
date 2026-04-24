vlib work
vlog counter.v counter_tb.sv COUNTER_PACKAGE.sv +cover -covercells
vsim -voptargs=+acc work.counter_tb -cover
coverage save counter.ucdb -onexit -du counter
#do wave.do
log -r /*
run -all
#quit -sim
#vcover report counter.ucdb -details -annotate -all -output cover_rpt.txt