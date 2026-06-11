onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {=== Clock / Reset ===}
add wave -noupdate /tb_multicycle/clk
add wave -noupdate /tb_multicycle/reset
add wave -noupdate -divider {=== Top-level I/O ===}
add wave -noupdate -label Adr -radix unsigned /tb_multicycle/Adr
add wave -noupdate -label WriteData -radix unsigned /tb_multicycle/WriteData
add wave -noupdate -label MemWrite -radix binary /tb_multicycle/MemWrite
add wave -noupdate -divider {=== FSM State ===}
add wave -noupdate -label State -radix unsigned /tb_multicycle/dut/rvcore/c/fsm/state
add wave -noupdate -label NextState -radix unsigned /tb_multicycle/dut/rvcore/c/fsm/nextstate
add wave -noupdate -divider {=== Datapath ===}
add wave -noupdate -label Instr -radix hexadecimal /tb_multicycle/dut/rvcore/dp/Instr
add wave -noupdate -label PC -radix unsigned /tb_multicycle/dut/rvcore/dp/PC
add wave -noupdate -label OldPC -radix unsigned /tb_multicycle/dut/rvcore/dp/OldPC
add wave -noupdate -label ALUResult -radix unsigned /tb_multicycle/dut/rvcore/dp/ALUResult
add wave -noupdate -label ALUOut -radix unsigned /tb_multicycle/dut/rvcore/dp/ALUOut
add wave -noupdate -label Result -radix unsigned /tb_multicycle/dut/rvcore/dp/Result
add wave -noupdate -label Zero -radix binary /tb_multicycle/dut/rvcore/dp/Zero
add wave -noupdate -divider {=== Control Signals ===}
add wave -noupdate -label IRWrite -radix binary /tb_multicycle/dut/rvcore/c/IRWrite
add wave -noupdate -label PCWrite -radix binary /tb_multicycle/dut/rvcore/c/PCWrite
add wave -noupdate -label AdrSrc -radix binary /tb_multicycle/dut/rvcore/c/AdrSrc
add wave -noupdate -label ALUSrcA -radix binary /tb_multicycle/dut/rvcore/c/ALUSrcA
add wave -noupdate -label ALUSrcB -radix binary /tb_multicycle/dut/rvcore/c/ALUSrcB
add wave -noupdate -label ResultSrc -radix binary /tb_multicycle/dut/rvcore/c/ResultSrc
add wave -noupdate -label ALUControl -radix binary /tb_multicycle/dut/rvcore/c/ALUControl
add wave -noupdate -label RegWrite -radix binary /tb_multicycle/dut/rvcore/c/RegWrite
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {250 ns}
