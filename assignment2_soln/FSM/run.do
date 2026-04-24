vlib work
vlog FSM_PACKAGE.sv FSM_010.v FSM_tb.sv +cover -covercells
vsim -voptargs=+acc work.FSM_tb -cover
coverage save FSM.ucdb -onexit -du FSM_010
#do wave.do
log -r /*
run -all
coverage exclude -src FSM_010.v -line 42 -code s
coverage exclude -src FSM_010.v -line 42 -code b
coverage exclude -du FSM_010 -ftrans cs ZERO->IDLE
coverage exclude -du FSM_010 -togglenode {users_count[6]}
coverage exclude -du FSM_010 -togglenode {users_count[7]}
coverage exclude -du FSM_010 -togglenode {users_count[8]}
coverage exclude -du FSM_010 -togglenode {users_count[9]}
#quit -sim
#vcover report FSM.ucdb -details -annotate -all -output cover_rpt.txt