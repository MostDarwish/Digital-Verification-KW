vlib work
vlog -f src_files.list +cover -covercells +define+SIM 
vsim -voptargs=+acc work.TOP -cover
coverage save FIFO.ucdb -onexit
log -r /*
run -all
#quit -sim
#vcover report FIFO.ucdb -du=FIFO -details -annotate -all -output code_cover_rpt.txt
#vcover report FIFO.ucdb -assert -directive -du=FIFO -details -output sva_cover_rpt.txt
#vcover report FIFO.ucdb -package=FIFO_coverage_pkg -cvg -details -annotate -all -output fun_cover_rpt.txt
