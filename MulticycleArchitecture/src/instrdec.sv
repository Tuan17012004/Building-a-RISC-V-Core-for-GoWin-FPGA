module instrdec (
    input  [6:0] op,
    output reg [1:0] ImmSrc
);
    always @(*)
        case (op)
            7'b0000011: ImmSrc = 2'b00;
            7'b0100011: ImmSrc = 2'b01;
            7'b0110011: ImmSrc = 2'b00;
            7'b1100011: ImmSrc = 2'b10;
            7'b0010011: ImmSrc = 2'b00;
            7'b1101111: ImmSrc = 2'b11;
            default:    ImmSrc = 2'b00;
        endcase
endmodule
