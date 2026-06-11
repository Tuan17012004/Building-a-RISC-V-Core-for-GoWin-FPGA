module datapath (
    input        clk, reset,
    input  [1:0] ImmSrc,
    input  [1:0] ALUSrcA, ALUSrcB,
    input  [1:0] ResultSrc,
    input        AdrSrc,
    input  [2:0] ALUControl,
    input        IRWrite, PCWrite,
    input        RegWrite,
    output [31:0] Adr, WriteData,
    input  [31:0] ReadData,
    output [31:0] Instr,
    output        Zero
);
    wire [31:0] PC, OldPC;
    wire [31:0] Data;
    wire [31:0] RD1, RD2;
    wire [31:0] A;
    wire [31:0] ImmExt;
    wire [31:0] SrcA, SrcB;
    wire [31:0] ALUResult, ALUOut;
    wire [31:0] Result;

    flopenr #(32) pcreg    (clk, reset, PCWrite, Result, PC);
    mux2    #(32) adrmux   (PC, Result, AdrSrc, Adr);
    flopenr #(32) instrreg (clk, reset, IRWrite, ReadData, Instr);
    flopenr #(32) oldpcreg (clk, reset, IRWrite, PC, OldPC);
    flopr   #(32) datareg  (clk, reset, ReadData, Data);

    regfile rf (
        .clk(clk),
        .we3(RegWrite),
        .a1(Instr[19:15]),
        .a2(Instr[24:20]),
        .a3(Instr[11:7]),
        .wd3(Result),
        .rd1(RD1), .rd2(RD2)
    );

    flopr   #(32) areg     (clk, reset, RD1, A);
    flopr   #(32) breg     (clk, reset, RD2, WriteData);
    extend  ext            (Instr[31:7], ImmSrc, ImmExt);
    mux3    #(32) srcamux  (PC, OldPC, A, ALUSrcA, SrcA);
    mux3    #(32) srcbmux  (WriteData, ImmExt, 32'd4, ALUSrcB, SrcB);
    alu     alu_inst       (SrcA, SrcB, ALUControl, ALUResult, Zero);
    flopr   #(32) aloutreg (clk, reset, ALUResult, ALUOut);
    mux3    #(32) resultmux(ALUOut, Data, ALUResult, ResultSrc, Result);
endmodule
