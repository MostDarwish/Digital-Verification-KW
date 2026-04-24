onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ALSU_tb/ALSU_DUT/clk
add wave -noupdate /ALSU_tb/ALSU_DUT/rst
add wave -noupdate -radix decimal /ALSU_tb/ALSU_DUT/A
add wave -noupdate -radix decimal /ALSU_tb/ALSU_DUT/B
add wave -noupdate /ALSU_tb/ALSU_DUT/cin
add wave -noupdate /ALSU_tb/ALSU_DUT/out
add wave -noupdate /ALSU_tb/ALSU_DUT/leds
add wave -noupdate /ALSU_tb/ALSU_DUT/red_op_A
add wave -noupdate /ALSU_tb/ALSU_DUT/red_op_B
add wave -noupdate /ALSU_tb/ALSU_DUT/bypass_A
add wave -noupdate /ALSU_tb/ALSU_DUT/bypass_B
add wave -noupdate /ALSU_tb/ALSU_DUT/direction
add wave -noupdate /ALSU_tb/ALSU_DUT/serial_in
add wave -noupdate /ALSU_tb/opcode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {33 ns}
