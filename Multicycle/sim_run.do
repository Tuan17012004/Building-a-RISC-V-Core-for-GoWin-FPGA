# ModelSim cho RISC-V Multi-Cycle Processor — MulticycleArchitecture
# Chay tu thu muc MulticycleArchitecture/: do sim_run.do

vlib work

# Compile bottom-up (module la phai truoc), source nam trong src/
vlog -sv src/alu.sv
vlog -sv src/aludec.sv
vlog -sv src/instrdec.sv
vlog -sv src/mainfsm.sv
vlog -sv src/extend.sv
vlog -sv src/flopr.sv
vlog -sv src/flopenr.sv
vlog -sv src/mux2.sv
vlog -sv src/mux3.sv
vlog -sv src/regfile.sv
vlog -sv src/mem.sv
vlog -sv src/datapath.sv
vlog -sv src/controller.sv
vlog -sv src/riscv.sv
vlog -sv src/top.sv
vlog -sv src/tb_multicycle.sv

vsim -t 1ns tb_multicycle

# Nap chuong trinh counter vao unified memory
mem load -infile src/program_counter.hex -format hex {/tb_multicycle/dut/m/RAM}

# === Clock / Reset ===
add wave -divider "=== Clock / Reset ==="
add wave                                      sim:/tb_multicycle/clk
add wave                                      sim:/tb_multicycle/reset

# === Top-level I/O ===
add wave -divider "=== Top-level I/O ==="
add wave -radix unsigned -label "Adr"         sim:/tb_multicycle/Adr
add wave -radix unsigned -label "WriteData"   sim:/tb_multicycle/WriteData
add wave -binary         -label "MemWrite"    sim:/tb_multicycle/MemWrite

# === FSM State (chung minh multi-cycle: moi lenh nhieu trang thai) ===
add wave -divider "=== FSM State ==="
add wave -radix unsigned -label "State"       sim:/tb_multicycle/dut/rvcore/c/fsm/state
add wave -radix unsigned -label "NextState"   sim:/tb_multicycle/dut/rvcore/c/fsm/nextstate

# === Datapath ===
add wave -divider "=== Datapath ==="
add wave -radix hex      -label "Instr"       sim:/tb_multicycle/dut/rvcore/dp/Instr
add wave -radix unsigned -label "PC"          sim:/tb_multicycle/dut/rvcore/dp/PC
add wave -radix unsigned -label "OldPC"       sim:/tb_multicycle/dut/rvcore/dp/OldPC
add wave -radix unsigned -label "ALUResult"   sim:/tb_multicycle/dut/rvcore/dp/ALUResult
add wave -radix unsigned -label "ALUOut"      sim:/tb_multicycle/dut/rvcore/dp/ALUOut
add wave -radix unsigned -label "Result"      sim:/tb_multicycle/dut/rvcore/dp/Result
add wave -binary         -label "Zero"        sim:/tb_multicycle/dut/rvcore/dp/Zero

# === Control Signals ===
add wave -divider "=== Control Signals ==="
add wave -binary         -label "IRWrite"     sim:/tb_multicycle/dut/rvcore/c/IRWrite
add wave -binary         -label "PCWrite"     sim:/tb_multicycle/dut/rvcore/c/PCWrite
add wave -binary         -label "AdrSrc"      sim:/tb_multicycle/dut/rvcore/c/AdrSrc
add wave -radix binary   -label "ALUSrcA"     sim:/tb_multicycle/dut/rvcore/c/ALUSrcA
add wave -radix binary   -label "ALUSrcB"     sim:/tb_multicycle/dut/rvcore/c/ALUSrcB
add wave -radix binary   -label "ResultSrc"   sim:/tb_multicycle/dut/rvcore/c/ResultSrc
add wave -radix binary   -label "ALUControl"  sim:/tb_multicycle/dut/rvcore/c/ALUControl
add wave -binary         -label "RegWrite"    sim:/tb_multicycle/dut/rvcore/c/RegWrite

run -all
