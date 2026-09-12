onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_programmable_pulse_generator/testing
add wave -noupdate -height 25 /tb_programmable_pulse_generator/clk
add wave -noupdate -height 25 /tb_programmable_pulse_generator/resetn
add wave -noupdate -height 25 /tb_programmable_pulse_generator/load_delay
add wave -noupdate -height 25 /tb_programmable_pulse_generator/load_length
add wave -noupdate -height 25 -radix decimal /tb_programmable_pulse_generator/data
add wave -noupdate -divider {DFF Length}
add wave -noupdate -height 25 -radix decimal /tb_programmable_pulse_generator/prog_pulse_gen/out_dff_len
add wave -noupdate -divider {DFF Delay}
add wave -noupdate -height 25 -radix decimal /tb_programmable_pulse_generator/prog_pulse_gen/out_dff_delay
add wave -noupdate -divider Wave
add wave -noupdate -color Yellow -height 25 /tb_programmable_pulse_generator/pulse
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Test 1} {0 ps} 1} {{Test 2} {100037 ps} 1} {{Test 3} {1499678 ps} 1} {{Test 4} {2397863 ps} 1} {{Test 5} {3699558 ps} 1} {{Test 6} {4795489 ps} 1} {{Test 7} {5097857 ps} 1} {{Test 8} {5897588 ps} 1} {{Test 9} {6697820 ps} 1}
quietly wave cursor active 0
configure wave -namecolwidth 125
configure wave -valuecolwidth 41
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
WaveRestoreZoom {0 ps} {8242500 ps}
