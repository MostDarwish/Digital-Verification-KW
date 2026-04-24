vlib work
vlog my_mem.sv my_mem_tb.sv
vsim -voptargs=+acc work.my_mem_tb
log -r /*
run -all
#quit -sim
