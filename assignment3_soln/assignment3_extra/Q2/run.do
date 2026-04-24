vlib work
vlog adder_pkg.sv adder.v adder_tb.sv  +cover -covercells
vsim -voptargs=+acc work.adder_tb -cover
coverage save adder_tb.ucdb -onexit
#do wave.do
#log -r /*
run -all
#quit -sim
#vcover report adder_tb.ucdb -du=adder -details -annotate -all -output code_cover_rpt.txt
#vcover report adder_tb.ucdb -package=adder_pkg -cvg -details -annotate -all -output fun_cover_rpt.txt