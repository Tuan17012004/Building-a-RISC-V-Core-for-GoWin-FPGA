module maindec (
    input  [6:0] op,
    output [1:0] ResultSrc,
    output       MemWrite,
    output       Branch,
    output       ALUSrc,
    output       RegWrite,
    output       Jump,
    output [1:0] ImmSrc,
    output [1:0] ALUOp
);
    reg [10:0] controls;
    assign {RegWrite, ImmSrc, ALUSrc, MemWrite,
            ResultSrc, Branch, ALUOp, Jump} = controls;
    always @(*)
        case (op)
            7'b0000011: controls = 11'b1_00_1_0_01_0_00_0;
            7'b0100011: controls = 11'b0_01_1_1_00_0_00_0;
            7'b0110011: controls = 11'b1_00_0_0_00_0_10_0;
            7'b1100011: controls = 11'b0_10_0_0_00_1_01_0;
            7'b0010011: controls = 11'b1_00_1_0_00_0_10_0;
            7'b1101111: controls = 11'b1_11_0_0_10_0_00_1;
            7'b0000000: controls = 11'b0_00_0_0_00_0_00_0;
            default:    controls = 11'bx;
        endcase
endmodule
