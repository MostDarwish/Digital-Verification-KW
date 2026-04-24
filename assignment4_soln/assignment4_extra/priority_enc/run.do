vlib work
vlog priority_enc.v priority_enc_tb.sv pencoder_sva.sv TOP.sv  +cover -covercells
vsim -voptargs=+acc work.TOP -cover
coverage save TOP.ucdb -onexit
log -r /*
run -all
#quit -sim
#vcover report TOP.ucdb -details -annotate -all -output cover_rpt.txt