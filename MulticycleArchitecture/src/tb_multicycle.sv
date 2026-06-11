`timescale 1ns/1ps

// Chung minh Multi-Cycle: moi lenh RISC-V mat nhieu chu ky clock
// [FIX 2025-06-06] Doi chuong trinh tu 3 lenh sang 4 lenh (giong single-cycle):
//   LY DO: Chuong trinh 3 lenh cu (addi/sw/jal-PC0) bi loi vi
//   sw x1,0(x0) ghi de RAM[0] roi jal nhay ve PC=0=da bi hong.
//   Chuong trinh 4 lenh moi: vong lap bat dau tu PC=4, sw ghi RAM[0]
//   nhung jal nhay ve PC=4 (khong quay ve PC=0) nen an toan.
//   PC=0:  addi x1,x0,0  (init x1=0, chay 1 lan duy nhat)
//   PC=4:  addi x1,x1,1  (vong lap: x1++)
//   PC=8:  sw   x1,0(x0) (MemWrite=1, ghi x1 vao RAM[0])
//   PC=12: jal  x0,-8    (nhay ve PC=4, vong lap khong qua PC=0)
// Moi lenh: 4 trang thai FSM → 12 chu ky/vong lap
// Luu y: tai trang thai FETCH, Instr la gia tri cu (chua cap nhat)
module tb_multicycle;
    reg         clk, reset;
    wire [31:0] WriteData, Adr;
    wire        MemWrite;

    top dut (
        .clk(clk), .reset(reset),
        .WriteData(WriteData), .Adr(Adr), .MemWrite(MemWrite)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        reset = 1; #45;
        reset = 0;
        repeat(48) @(posedge clk);
        $finish;
    end

    integer cycle = 0;
    always @(negedge clk) begin
        if (!reset) begin
            cycle = cycle + 1;
            $write("Cycle %2d | ", cycle);
            case (dut.rvcore.c.fsm.state)
                4'd0:  $write("FETCH    ");
                4'd1:  $write("DECODE   ");
                4'd2:  $write("MEMADR   ");
                4'd3:  $write("MEMREAD  ");
                4'd4:  $write("MEMWB    ");
                4'd5:  $write("MEMWRITE ");
                4'd6:  $write("EXECR    ");
                4'd7:  $write("ALUWB    ");
                4'd8:  $write("EXECI    ");
                4'd9:  $write("JAL      ");
                4'd10: $write("BEQ      ");
                default: $write("???      ");
            endcase
            // Giai ma lenh tu opcode
            $write("| ");
            case (dut.rvcore.dp.Instr[6:0])
                7'b0010011: $write("addi x%0d,x%0d,%0d",
                    dut.rvcore.dp.Instr[11:7],
                    dut.rvcore.dp.Instr[19:15],
                    $signed(dut.rvcore.dp.Instr[31:20]));
                7'b0100011: $write("sw   x%0d,%0d(x%0d)",
                    dut.rvcore.dp.Instr[24:20],
                    $signed({dut.rvcore.dp.Instr[31:25], dut.rvcore.dp.Instr[11:7]}),
                    dut.rvcore.dp.Instr[19:15]);
                7'b1101111: $write("jal  x%0d,%0d",
                    dut.rvcore.dp.Instr[11:7],
                    $signed({dut.rvcore.dp.Instr[31],
                              dut.rvcore.dp.Instr[19:12],
                              dut.rvcore.dp.Instr[20],
                              dut.rvcore.dp.Instr[30:21], 1'b0}));
                default: $write("Instr=%h", dut.rvcore.dp.Instr);
            endcase
            $write(" | PC=%2d", dut.rvcore.dp.PC);
            if (MemWrite) $write(" | MEM[%0d]=%0d <=", Adr, WriteData);
            $display("");
        end
    end
endmodule
