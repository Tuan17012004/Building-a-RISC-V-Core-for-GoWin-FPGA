module mainfsm (
    input        clk, reset,
    input  [6:0] op,
    output [1:0] ALUOp,
    output [1:0] ResultSrc,
    output [1:0] ALUSrcB,
    output [1:0] ALUSrcA,
    output       AdrSrc,
    output       IRWrite,
    output       PCUpdate,
    output       RegWrite,
    output       MemWrite,
    output       Branch
);
    localparam S0_FETCH    = 4'd0;
    localparam S1_DECODE   = 4'd1;
    localparam S2_MEMADR   = 4'd2;
    localparam S3_MEMREAD  = 4'd3;
    localparam S4_MEMWB    = 4'd4;
    localparam S5_MEMWRITE = 4'd5;
    localparam S6_EXECR    = 4'd6;
    localparam S7_ALUWB    = 4'd7;
    localparam S8_EXECI    = 4'd8;
    localparam S9_JAL      = 4'd9;
    localparam S10_BEQ     = 4'd10;

    reg [3:0]  state, nextstate;
    reg [13:0] controls;

    always @(posedge clk or posedge reset)
        if (reset) state <= S0_FETCH;
        else       state <= nextstate;

    always @(*)
        case (state)
            S0_FETCH:  nextstate = S1_DECODE;
            S1_DECODE:
                case (op)
                    7'b0000011: nextstate = S2_MEMADR;
                    7'b0100011: nextstate = S2_MEMADR;
                    7'b0110011: nextstate = S6_EXECR;
                    7'b1100011: nextstate = S10_BEQ;
                    7'b0010011: nextstate = S8_EXECI;
                    7'b1101111: nextstate = S9_JAL;
                    default:    nextstate = S0_FETCH;
                endcase
            S2_MEMADR:
                case (op)
                    7'b0000011: nextstate = S3_MEMREAD;
                    7'b0100011: nextstate = S5_MEMWRITE;
                    default:    nextstate = S0_FETCH;
                endcase
            S3_MEMREAD:  nextstate = S4_MEMWB;
            S4_MEMWB:    nextstate = S0_FETCH;
            S5_MEMWRITE: nextstate = S0_FETCH;
            S6_EXECR:    nextstate = S7_ALUWB;
            S7_ALUWB:    nextstate = S0_FETCH;
            S8_EXECI:    nextstate = S7_ALUWB;
            S9_JAL:      nextstate = S7_ALUWB;
            S10_BEQ:     nextstate = S0_FETCH;
            default:     nextstate = S0_FETCH;
        endcase

    assign {AdrSrc, IRWrite, ALUSrcA, ALUSrcB, ALUOp,
            ResultSrc, PCUpdate, RegWrite, MemWrite, Branch} = controls;

    always @(*)
        case (state)
            S0_FETCH:    controls = 14'b0_1_00_10_00_10_1_0_0_0;
            S1_DECODE:   controls = 14'b0_0_01_01_00_00_0_0_0_0;
            S2_MEMADR:   controls = 14'b0_0_10_01_00_00_0_0_0_0;
            S3_MEMREAD:  controls = 14'b1_0_00_00_00_00_0_0_0_0;
            S4_MEMWB:    controls = 14'b0_0_00_00_00_01_0_1_0_0;
            S5_MEMWRITE: controls = 14'b1_0_00_00_00_00_0_0_1_0;
            S6_EXECR:    controls = 14'b0_0_10_00_10_00_0_0_0_0;
            S7_ALUWB:    controls = 14'b0_0_00_00_00_00_0_1_0_0;
            S8_EXECI:    controls = 14'b0_0_10_01_10_00_0_0_0_0;
            S9_JAL:      controls = 14'b0_0_01_10_00_00_1_0_0_0;
            S10_BEQ:     controls = 14'b0_0_10_00_01_00_0_0_0_1;
            default:     controls = 14'b0;
        endcase
endmodule
