vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
coverage save alsu.ucdb -onexit
add wave /top/alsuif/*
add wave /top/shift_regif/*
run -all
coverage exclude -du ALSU -togglenode {cin_reg[1]}
coverage exclude -src ALSU.v -line 88 -code b
#quit -sim
#vcover report alsu.ucdb -du=ALSU -details -annotate -all -output code_cover_rpt.txt
