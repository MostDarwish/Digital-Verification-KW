vlib work
vlog testing_pkg.sv alu_seq.sv tb.sv +cover -covercells
vsim -voptargs=+acc work.tb -cover
coverage save alu.ucdb -onexit
#do wave.do
log -r /*
run -all
coverage exclude -src alu_seq.sv -line 18 -code b
coverage exclude -src alu_seq.sv -line 18 -code s
coverage exclude -src alu_seq.sv -line 17 -code s
coverage exclude -src alu_seq.sv -line 17 -code b
coverage exclude -du alu_seq -togglenode opcode
#quit -sim
#vcover report alu.ucdb -du=alu_seq -details -annotate -all -output code_cover_rpt.txt
#vcover report alu.ucdb -package=testing_pkg -cvg -details -annotate -all -output fun_cover_rpt.txt