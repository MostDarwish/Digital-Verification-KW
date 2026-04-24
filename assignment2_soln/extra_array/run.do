vlib work
vlog array.sv +cover -covercells
vsim -voptargs=+acc work.array -cover
run -all
quit -sim