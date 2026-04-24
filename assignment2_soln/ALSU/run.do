vlib work
vlog ALSU_PACKAGE.sv ALSU.v ALSU_tb.sv +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
coverage save ALSU.ucdb -onexit -du ALSU
do wave.do
log -r /*
run -all
coverage exclude -src ALSU.v -line 76 -code b
coverage exclude -du ALSU -togglenode {cin_reg[1]}
#quit -sim
#vcover report ALSU.ucdb -details -annotate -all -output cover_rpt.txt