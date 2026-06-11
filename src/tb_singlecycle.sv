`timescale 1ns/1ps

// Chung minh Single-Cycle: moi chu ky clock thuc thi dung 1 lenh RISC-V
module tb_singlecycle;
    reg         clk, reset;
    wire [31:0] PC, Instr, ALUResult, WriteData, ReadData;
    wire        MemWrite;

    riscvsingle cpu (
        .clk(clk), .reset(reset), .PC(PC), .Instr(Instr),
        .MemWrite(MemWrite), .ALUResult(ALUResult),
        .WriteData(WriteData), .ReadData(ReadData)
    );
    imem imem (.a(PC), .rd(Instr));
    dmem dmem (.clk(clk), .we(MemWrite), .a(ALUResult), .wd(WriteData), .rd(ReadData));

    // Clock 50 MHz: chu ky 20ns
    initial clk = 0;
    always #10 clk = ~clk;

    // Reset 2 chu ky, sau do chay 16 chu ky
    initial begin
        reset = 1; #45;
        reset = 0;
        repeat(16) @(posedge clk);
        $finish;
    end

    // In tung chu ky clock de chung minh single-cycle
    integer cycle = 0;
    always @(negedge clk) begin
        if (!reset) begin
            cycle = cycle + 1;
            $write("Cycle %2d | PC=%2d | ", cycle, PC);
            // Giai ma ten lenh tu opcode
            case (Instr[6:0])
                7'b0010011: $write("addi  x%0d, x%0d, %0d",
                                Instr[11:7], Instr[19:15], $signed(Instr[31:20]));
                7'b0100011: $write("sw    x%0d, %0d(x%0d) -> MEM[%0d]=%0d",
                                Instr[24:20], $signed({Instr[31:25],Instr[11:7]}),
                                Instr[19:15], ALUResult, WriteData);
                7'b1101111: $write("jal   x%0d, %0d       -> PC_next=%0d",
                                Instr[11:7],
                                $signed({Instr[31],Instr[19:12],Instr[20],Instr[30:21],1'b0}),
                                ALUResult);
                default:    $write("opcode=%7b", Instr[6:0]);
            endcase
            $display("");
        end
    end
endmodule
