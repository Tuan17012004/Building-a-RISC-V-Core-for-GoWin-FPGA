module controller (
    input        clk, reset,
    input  [6:0] op,
    input  [2:0] funct3,
    input        funct7b5,
    input        Zero,
    output [1:0] ImmSrc,
    output [1:0] ALUSrcA, ALUSrcB,
    output [1:0] ResultSrc,
    output       AdrSrc,
    output [2:0] ALUControl,
    output       IRWrite, PCWrite,
    output       RegWrite, MemWrite
);
    wire [1:0] ALUOp;
    wire       Branch;
    wire       PCUpdate;

    mainfsm fsm (
        .clk(clk), .reset(reset),
        .op(op),
        .ALUOp(ALUOp),
        .ResultSrc(ResultSrc),
        .ALUSrcB(ALUSrcB),
        .ALUSrcA(ALUSrcA),
        .AdrSrc(AdrSrc),
        .IRWrite(IRWrite), .PCUpdate(PCUpdate),
        .RegWrite(RegWrite), .MemWrite(MemWrite),
        .Branch(Branch)
    );

    aludec ad (
        .opb5(op[5]),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    instrdec id (
        .op(op),
        .ImmSrc(ImmSrc)
    );

    assign PCWrite = PCUpdate | (Branch & Zero);
endmodule
