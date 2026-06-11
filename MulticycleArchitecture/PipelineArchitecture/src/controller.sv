module controller (
    input        clk, reset,
    input  [6:0] opD,
    input  [2:0] funct3D,
    input        funct7b5D,
    output [1:0] ImmSrcD,
    input        FlushE,
    input        ZeroE,
    output       PCSrcE,
    output [2:0] ALUControlE,
    output       ALUSrcE,
    output       ResultSrcEb0,
    output       MemWriteM,
    output       RegWriteM,
    output       RegWriteW,
    output [1:0] ResultSrcW
);
    wire       RegWriteD;
    wire [1:0] ResultSrcD;
    wire       MemWriteD;
    wire       JumpD, BranchD;
    wire [1:0] ALUOpD;
    wire [2:0] ALUControlD;
    wire       ALUSrcD;
    wire       RegWriteE;
    wire [1:0] ResultSrcE;
    wire       MemWriteE;
    wire       JumpE, BranchE;
    wire [1:0] ResultSrcM;

    maindec md (
        opD, ResultSrcD, MemWriteD, BranchD,
        ALUSrcD, RegWriteD, JumpD, ImmSrcD, ALUOpD
    );
    aludec ad (
        opD[5], funct3D, funct7b5D, ALUOpD, ALUControlD
    );

    floprc #(10) controlregE (
        clk, reset, FlushE,
        {RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD,
         ALUControlD, ALUSrcD},
        {RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE,
         ALUControlE, ALUSrcE}
    );

    assign PCSrcE       = (BranchE & ZeroE) | JumpE;
    assign ResultSrcEb0 = ResultSrcE[0];

    flopr #(4) controlregM (
        clk, reset,
        {RegWriteE, ResultSrcE, MemWriteE},
        {RegWriteM, ResultSrcM, MemWriteM}
    );

    flopr #(3) controlregW (
        clk, reset,
        {RegWriteM, ResultSrcM},
        {RegWriteW, ResultSrcW}
    );
endmodule
