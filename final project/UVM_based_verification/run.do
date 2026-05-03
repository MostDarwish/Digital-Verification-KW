vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.TOP -classdebug -uvmcontrol=all -cover
coverage save alsu.ucdb -onexit
add wave /TOP/intf/*
log -r /*
run -all