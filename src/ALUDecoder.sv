module aludec(
    input        opb5,
    input  [2:0] funct3,
    input        funct7b5,
    input  [1:0] ALUOp,
    output reg [2:0] ALUControl
);
    wire RTypeSub;
    assign RTypeSub = funct7b5 & opb5;

    always @(*)
        case(ALUOp)
            2'b00: ALUControl = 3'b000;
            2'b01: ALUControl = 3'b001;
            2'b10:
                case(funct3)
                    3'b000: ALUControl = RTypeSub ? 3'b001 : 3'b000;
                    3'b010: ALUControl = 3'b101;
                    3'b100: ALUControl = 3'b100;
                    3'b110: ALUControl = 3'b011;
                    3'b111: ALUControl = 3'b010;
                    default: ALUControl = 3'bxxx;
                endcase
            default: ALUControl = 3'bxxx;
        endcase
endmodule
