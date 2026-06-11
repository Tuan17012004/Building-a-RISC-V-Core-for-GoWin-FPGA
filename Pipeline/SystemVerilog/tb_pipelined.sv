`timescale 1ns/1ps

// Chung minh Pipeline 5-stage: moi chu ky co nhieu lenh chay song song
// Program: addi x1,x1,1 → sw x1,0(x0) → jal x0,-8 (lap lai)
// Hien thi: stage F, stage D, hazard (stall/flush/forward)
module tb_pipelined;
    reg         clk, reset;
    wire [31:0] WriteDataM, DataAdrM;
    wire        MemWriteM;

    top dut (
        .clk(clk), .reset(reset),
        .WriteDataM(WriteDataM),
        .DataAdrM(DataAdrM),
        .MemWriteM(MemWriteM)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        reset = 1; #45;
        reset = 0;
        repeat(30) @(posedge clk);
        $finish;
    end

    // Giai ma ten lenh tu opcode
    task write_instr;
        input [6:0] op;
        case (op)
            7'b0010011: $write("addi");
            7'b0100011: $write("sw  ");
            7'b1101111: $write("jal ");
            7'b0000000: $write("nop ");
            default:    $write("--- ");
        endcase
    endtask

    integer cycle = 0;
    always @(negedge clk) begin
        if (!reset) begin
            cycle = cycle + 1;
            // Stage F: lenh dang fetch
            $write("Cycle %2d | F[PC=%2d ", cycle, dut.PCF);
            write_instr(dut.InstrF[6:0]);
            $write("]");

            // Stage D: lenh dang decode
            $write(" D[PC=%2d ", dut.riscv.dp.PCD);
            write_instr(dut.riscv.dp.InstrD[6:0]);
            $write("]");

            // Hazard signals
            if (dut.riscv.hu.StallF)
                $write(" STALL");
            if (dut.riscv.hu.FlushD)
                $write(" FLUSH_D");
            if (dut.riscv.hu.FlushE)
                $write(" FLUSH_E");
            if (dut.riscv.hu.ForwardAE != 2'b00)
                $write(" FWD_A=%b", dut.riscv.hu.ForwardAE);
            if (dut.riscv.hu.ForwardBE != 2'b00)
                $write(" FWD_B=%b", dut.riscv.hu.ForwardBE);

            // Stage M: ghi bo nho
            if (MemWriteM)
                $write(" | M: MEM[%0d]=%0d <=", DataAdrM, WriteDataM);

            $display("");
        end
    end
endmodule
