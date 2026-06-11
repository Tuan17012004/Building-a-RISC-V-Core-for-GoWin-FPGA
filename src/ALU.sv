// ALU ho tro: add, sub, and, or, xor, slt
module alu(
    input  [31:0] a, b,
    input  [2:0]  alucontrol,
    output reg [31:0] result,
    output        zero
);
    wire [31:0] condinvb, sum;
    assign condinvb = alucontrol[0] ? ~b : b;
    assign sum      = a + condinvb + {31'b0, alucontrol[0]};

    always @(*)
        case(alucontrol)
            3'b000: result = sum;
            3'b001: result = sum;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = {31'b0, ($signed(a) < $signed(b))};
            default: result = 32'bx;
        endcase

    assign zero = (result == 32'b0);
endmodule
