# Script ModelSim cho RISC-V Single-Cycle
# Chay trong ModelSim: do sim_run.do

vlib work

# Compile theo thu tu bottom-up (module la phai truoc)
vlog -sv src/Adder.sv
vlog -sv src/multiplexer21.sv
vlog -sv src/multiplexer31.sv
vlog -sv src/ResettableFF.sv
vlog -sv src/Resettableffwen.sv
vlog -sv src/ProgramCounter.sv
vlog -sv src/ALU.sv
vlog -sv src/ALUDecoder.sv
vlog -sv src/MainDecoder.sv
vlog -sv src/Controller.sv
vlog -sv src/RegFile.sv
vlog -sv src/ExtendUnit.sv
vlog -sv src/DataMemory.sv
vlog -sv src/InstructionMemory.sv
vlog -sv src/Datapath.sv
vlog -sv src/Single-CycleProcessor.sv
vlog -sv src/tb_singlecycle.sv

# Chay simulation
vsim -t 1ns tb_singlecycle

# ── Clock / Reset ──────────────────────────────────────────
add wave -divider "=== Clock / Reset ==="
add wave                                    sim:/tb_singlecycle/clk
add wave                                    sim:/tb_singlecycle/reset

# ── Datapath: PC va lenh ────────────────────────────────────
add wave -divider "=== Datapath ==="
add wave -radix unsigned                    sim:/tb_singlecycle/PC
add wave -radix hex                         sim:/tb_singlecycle/Instr
add wave -radix unsigned                    sim:/tb_singlecycle/ALUResult
add wave -radix unsigned                    sim:/tb_singlecycle/WriteData
add wave -radix unsigned                    sim:/tb_singlecycle/ReadData

# ── Control Unit: Main Decoder ──────────────────────────────
add wave -divider "=== Control Unit: Main Decoder ==="
add wave -radix binary  -label "op[6:0]"   sim:/tb_singlecycle/cpu/Instr[6:0]
add wave -binary        -label "RegWrite"   sim:/tb_singlecycle/cpu/c/md/RegWrite
add wave -radix binary  -label "ImmSrc"    sim:/tb_singlecycle/cpu/c/md/ImmSrc
add wave -binary        -label "ALUSrc"    sim:/tb_singlecycle/cpu/c/md/ALUSrc
add wave -binary        -label "MemWrite"  sim:/tb_singlecycle/cpu/c/md/MemWrite
add wave -radix binary  -label "ResultSrc" sim:/tb_singlecycle/cpu/c/md/ResultSrc
add wave -binary        -label "Branch"    sim:/tb_singlecycle/cpu/c/md/Branch
add wave -radix binary  -label "ALUOp"    sim:/tb_singlecycle/cpu/c/md/ALUOp
add wave -binary        -label "Jump"      sim:/tb_singlecycle/cpu/c/md/Jump

# ── Control Unit: ALU Decoder ───────────────────────────────
add wave -divider "=== Control Unit: ALU Decoder ==="
add wave -radix binary  -label "funct3"    sim:/tb_singlecycle/cpu/Instr[14:12]
add wave -binary        -label "funct7b5"  sim:/tb_singlecycle/cpu/Instr[30]
add wave -radix binary  -label "ALUControl" sim:/tb_singlecycle/cpu/c/ALUControl

# ── Control Unit: PC Source ─────────────────────────────────
add wave -divider "=== Control Unit: PC Logic ==="
add wave -binary        -label "Zero"      sim:/tb_singlecycle/cpu/Zero
add wave -binary        -label "PCSrc"     sim:/tb_singlecycle/cpu/c/PCSrc

# Chay het simulation
run -all
