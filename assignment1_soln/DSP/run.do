vlib work
vlog DSP.v DSP_tb.sv  +cover -covercells
vsim -voptargs=+acc work.DSP_tb -cover
coverage save DSP_tb.ucdb -onexit -du DSP
do wave.do
log -r /*
run -all
coverage exclude -du DSP -togglenode {mult_out[36]}
coverage exclude -du DSP -togglenode {mult_out[37]}
coverage exclude -du DSP -togglenode {mult_out[38]}
coverage exclude -du DSP -togglenode {mult_out[39]}
coverage exclude -du DSP -togglenode {mult_out[40]}
coverage exclude -du DSP -togglenode {mult_out[41]}
coverage exclude -du DSP -togglenode {mult_out[42]}
coverage exclude -du DSP -togglenode {mult_out[43]}
coverage exclude -du DSP -togglenode {mult_out[44]}
coverage exclude -du DSP -togglenode {mult_out[45]}
coverage exclude -du DSP -togglenode {mult_out[46]}
coverage exclude -du DSP -togglenode {mult_out[47]}
#quit -sim
#vcover report DSP_tb.ucdb -details -annotate -all -output cover_rpt.txt