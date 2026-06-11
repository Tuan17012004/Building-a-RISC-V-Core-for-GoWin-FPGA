module datapath(
    input         clk, reset,
    input  [1:0]  ResultSrc,
    input         PCSrc, ALUSrc, RegWrite,
    input  [1:0]  ImmSrc,
    input  [2:0]  ALUControl,
    output        Zero,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] ALUResult, WriteData,
    input  [31:0] ReadData
);
    wire [31:0] PCNext, PCPlus4, PCTarget, ImmExt, SrcA, SrcB, Result;
    flopr   #(32) pcreg   (clk, reset, PCNext, PC);
    adder         pcadd4  (PC, 32'd4, PCPlus4);
    adder         pcaddbr (PC, ImmExt, PCTarget);
    mux2to1 #(32) pcmux   (PCPlus4, PCTarget, PCSrc, PCNext);
    regfile rf (.clk(clk),.we3(RegWrite),.a1(Instr[19:15]),.a2(Instr[24:20]),.a3(Instr[11:7]),.wd3(Result),.rd1(SrcA),.rd2(WriteData));
    extend ext (.instr(Instr[31:7]),.immsrc(ImmSrc),.immext(ImmExt));
    mux2to1 #(32) srcbmux  (WriteData, ImmExt, ALUSrc, SrcB);
    alu            alu_inst (SrcA, SrcB, ALUControl, ALUResult, Zero);
    mux3    #(32) resultmux (ALUResult, ReadData, PCPlus4, ResultSrc, Result);
endmodule
