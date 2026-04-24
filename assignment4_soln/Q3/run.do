vlib work
vlog counter.v COUNTER_PACKAGE.sv count_if.sv counter_tb.sv counter_sva.sv counter_wrapper.sv TOP.sv +cover -covercells
vsim -voptargs=+acc work.TOP -cover
coverage save counter.ucdb -onexit
#do wave.do
log -r /*
run -all
#quit -sim
#vcover report counter.ucdb -du=counter -details -annotate -all -output code_cover_rpt.txt
#vcover report counter.ucdb -assert -directive -du=counter_sva -details -output sva_cover_rpt.txt
#vcover report counter.ucdb -package=COUNTER_PACKAGE -cvg -details -annotate -all -output fun_cover_rpt.txt