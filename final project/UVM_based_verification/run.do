vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.TOP -classdebug -uvmcontrol=all -cover
coverage save alsu.ucdb -onexit
add wave /TOP/intf/*
run -all
#quit -sim
#vcover report alsu.ucdb -du=ALSU -details -annotate -all -output code_cover_rpt.txt
