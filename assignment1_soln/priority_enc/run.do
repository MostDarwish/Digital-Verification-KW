vlib work
vlog priority_enc.v priority_enc_tb.sv  +cover -covercells
vsim -voptargs=+acc work.priority_enc_tb -cover
coverage save priority_enc_tb.ucdb -onexit -du priority_enc
log -r /*
run -all
#quit -sim
#vcover report priority_enc_tb.ucdb -details -annotate -all -output cover_rpt.txt