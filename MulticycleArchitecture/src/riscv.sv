module riscv (
    input        clk, reset,
    output [31:0] Adr, WriteData,
    input  [31:0] ReadData,
    output        MemWrite
);
    wire [31:0] Instr;
    wire        Zero;
    wire [1:0]  ImmSrc, ALUSrcA, ALUSrcB, ResultSrc;
    wire        AdrSrc;
    wire [2:0]  ALUControl;
    wire        IRWrite, PCWrite;
    wire        RegWrite;

    controller c (
        .clk(clk), .reset(reset),
        .op(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7b5(Instr[30]),
        .Zero(Zero),
        .ImmSrc(ImmSrc),
        .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc),
        .AdrSrc(AdrSrc),
        .ALUControl(ALUControl),
        .IRWrite(IRWrite), .PCWrite(PCWrite),
        .RegWrite(RegWrite), .MemWrite(MemWrite)
    );

    datapath dp (
        .clk(clk), .reset(reset),
        .ImmSrc(ImmSrc),
        .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc),
        .AdrSrc(AdrSrc),
        .ALUControl(ALUControl),
        .IRWrite(IRWrite), .PCWrite(PCWrite),
        .RegWrite(RegWrite),
        .Adr(Adr), .WriteData(WriteData),
        .ReadData(ReadData),
        .Instr(Instr), .Zero(Zero)
    );
endmodule
