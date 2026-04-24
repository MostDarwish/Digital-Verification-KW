vlib work
vlog ALU.v ALU_PACKAGE.sv ALU_tb.sv +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
coverage save ALU.ucdb -onexit -du ALU_4_bit
#do wave.do
log -r /*
run -all
coverage exclude -src ALU.v -line 26 -code s
coverage exclude -src ALU.v -line 26 -code b
#quit -sim
#vcover report ALU.ucdb -details -annotate -all -output cover_rpt.txt