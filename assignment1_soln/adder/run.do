vlib work
vlog adder.v adder_tb.sv  +cover -covercells
vsim -voptargs=+acc work.adder_tb -cover
coverage save adder_tb.ucdb -onexit -du adder
#do wave.do
#log -r /*
run -all
quit -sim
vcover report adder_tb.ucdb -details -annotate -all -output cover_rpt.txt