vlib work
vlog ALSU_PACKAGE.sv ALSU.v ALSU_tb.sv +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
coverage save ALSU.ucdb -onexit
log -r /*
run -all
coverage exclude -src ALSU.v -line 76 -code b
coverage exclude -du ALSU -togglenode {cin_reg[1]}
#quit -sim
#vcover report ALSU.ucdb -du=ALSU -details -annotate -all -output code_cover_rpt.txt
#vcover report ALSU.ucdb -package=ALSU_PACKAGE -cvg -details -annotate -all -output fun_cover_rpt.txt