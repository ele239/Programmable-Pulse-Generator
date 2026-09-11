onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_programmable_pulse_generator/clk
add wave -noupdate /tb_programmable_pulse_generator/resetn
add wave -noupdate /tb_programmable_pulse_generator/load_delay
add wave -noupdate /tb_programmable_pulse_generator/load_length
add wave -noupdate -radix decimal /tb_programmable_pulse_generator/data
add wave -noupdate /tb_programmable_pulse_generator/pulse
add wave -noupdate -label out_dff_len -radix decimal /tb_programmable_pulse_generator/prog_pulse_gen/dff_len/output
add wave -noupdate -label out_dff_delay -radix decimal /tb_programmable_pulse_generator/prog_pulse_gen/dff_delay/output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5526147 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {4873398 ps} {8217190 ps}
