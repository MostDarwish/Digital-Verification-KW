vlib work
vlog dff.v dff_t1_tb.sv dff_t2_tb.sv  +cover -covercells
vsim -voptargs=+acc work.dff_t1_tb -cover
coverage save dff_t1.ucdb -onexit -du dff
run -all
quit -sim
vcover report dff_t1.ucdb -details -annotate -all -output cover_rpt_t1.txt

vsim -voptargs=+acc work.dff_t2_tb -cover
coverage save dff_t2.ucdb -onexit -du dff
run -all
quit -sim
vcover report dff_t2.ucdb -details -annotate -all -output cover_rpt_t2.txt

vcover merge dff_merged.ucdb dff_t1.ucdb dff_t2.ucdb -du dff
vcover report dff_merged.ucdb -details -annotate -all -output cover_rpt_merged.txt