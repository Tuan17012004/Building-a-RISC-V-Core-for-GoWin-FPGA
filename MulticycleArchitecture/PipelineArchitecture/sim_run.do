# ModelSim cho RISC-V 5-Stage Pipelined Processor — PipelineArchitecture
# Chay tu thu muc PipelineArchitecture/: do sim_run.do
#
# [NOTE 2026-06-07] imem da doi sang case-statement ROM (khong con BSRAM),
#   nen khong can mem load cho imem nua. Chuong trinh nam trong RTL case.
#   dmem dung negedge write + posedge read, bat dau gia tri = 0 (hop le).

vlib work

# Compile bottom-up (module la phai truoc), source nam trong src/
vlog -sv src/alu.sv
vlog -sv src/aludec.sv
vlog -sv src/maindec.sv
vlog -sv src/adder.sv
vlog -sv src/extend.sv
vlog -sv src/flopr.sv
vlog -sv src/flopenr.sv
vlog -sv src/flopenrc.sv
vlog -sv src/floprc.sv
vlog -sv src/hazard.sv
vlog -sv src/imem.sv
vlog -sv src/dmem.sv
vlog -sv src/mux2.sv
vlog -sv src/mux3.sv
vlog -sv src/regfile.sv
vlog -sv src/datapath.sv
vlog -sv src/controller.sv
vlog -sv src/riscv.sv
vlog -sv src/top.sv
vlog -sv src/tb_pipelined.sv

vsim -t 1ns tb_pipelined

# === Clock / Reset ===
add wave -divider "=== Clock / Reset ==="
add wave                                       sim:/tb_pipelined/clk
add wave                                       sim:/tb_pipelined/reset

# === Stage F: Fetch ===
add wave -divider "=== Stage F: Fetch ==="
add wave -radix unsigned -label "PCF"          sim:/tb_pipelined/dut/PCF
add wave -radix hex      -label "InstrF"       sim:/tb_pipelined/dut/InstrF

# === Stage D: Decode ===
add wave -divider "=== Stage D: Decode ==="
add wave -radix unsigned -label "PCD"          sim:/tb_pipelined/dut/riscv/dp/PCD
add wave -radix hex      -label "InstrD"       sim:/tb_pipelined/dut/riscv/dp/InstrD

# === Stage E: Execute ===
add wave -divider "=== Stage E: Execute ==="
add wave -radix unsigned -label "PCE"          sim:/tb_pipelined/dut/riscv/dp/PCE
add wave -radix binary   -label "ALUControlE"  sim:/tb_pipelined/dut/riscv/c/ALUControlE
add wave -binary         -label "ALUSrcE"      sim:/tb_pipelined/dut/riscv/c/ALUSrcE
add wave -binary         -label "PCSrcE"       sim:/tb_pipelined/dut/riscv/c/PCSrcE
add wave -radix unsigned -label "ALUResultE"   sim:/tb_pipelined/dut/riscv/dp/ALUResultE

# === Stage M: Memory ===
add wave -divider "=== Stage M: Memory ==="
add wave -radix unsigned -label "DataAdrM"     sim:/tb_pipelined/DataAdrM
add wave -radix unsigned -label "WriteDataM"   sim:/tb_pipelined/WriteDataM
add wave -binary         -label "MemWriteM"    sim:/tb_pipelined/MemWriteM
add wave -binary         -label "RegWriteM"    sim:/tb_pipelined/dut/riscv/c/RegWriteM

# === Stage W: Writeback ===
add wave -divider "=== Stage W: Writeback ==="
add wave -binary         -label "RegWriteW"    sim:/tb_pipelined/dut/riscv/c/RegWriteW
add wave -radix binary   -label "ResultSrcW"   sim:/tb_pipelined/dut/riscv/c/ResultSrcW

# === Hazard Unit ===
add wave -divider "=== Hazard Unit ==="
add wave -binary         -label "StallF"       sim:/tb_pipelined/dut/riscv/hu/StallF
add wave -binary         -label "StallD"       sim:/tb_pipelined/dut/riscv/hu/StallD
add wave -binary         -label "FlushD"       sim:/tb_pipelined/dut/riscv/hu/FlushD
add wave -binary         -label "FlushE"       sim:/tb_pipelined/dut/riscv/hu/FlushE
add wave -radix binary   -label "ForwardAE"    sim:/tb_pipelined/dut/riscv/hu/ForwardAE
add wave -radix binary   -label "ForwardBE"    sim:/tb_pipelined/dut/riscv/hu/ForwardBE

run -all
