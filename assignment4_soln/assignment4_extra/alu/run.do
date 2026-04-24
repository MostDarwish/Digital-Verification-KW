vlib work
vlog ALU.v ALU_tb.sv ALU_sva.sv TOP.sv +cover -covercells
vsim -voptargs=+acc work.TOP -cover
coverage save TOP.ucdb -onexit
#do wave.do
log -r /*
run -all
coverage exclude -src ALU.v -line 26 -code s
coverage exclude -src ALU.v -line 26 -code b
#quit -sim
#vcover report TOP.ucdb -du=ALU_4_bit -details -annotate -all -output code_cover_rpt.txt
#vcover report TOP.ucdb -assert -directive -du=ALU_sva -details -output sva_cover_rpt.txt