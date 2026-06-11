module datapath (
    input        clk, reset,
    input        StallF,
    output [31:0] PCF,
    input  [31:0] InstrF,
    output [6:0]  opD,
    output [2:0]  funct3D,
    output        funct7b5D,
    input         StallD, FlushD,
    input  [1:0]  ImmSrcD,
    input         FlushE,
    input  [1:0]  ForwardAE, ForwardBE,
    input         PCSrcE,
    input  [2:0]  ALUControlE,
    input         ALUSrcE,
    output        ZeroE,
    input         MemWriteM,
    output [31:0] WritedataM, ALUResultM,
    // [FIX 2026-06-07] Doi ReadDataM → ReadDataW (dmem da tu register output).
    // LY DO: dmem dung sync read → output cua no chinh la ReadDataW (da tre 1 cycle).
    // Khong can regW latch them lan nua, tranh double-latch.
    input  [31:0] ReadDataW,
    input         RegWriteW,
    input  [1:0]  ResultSrcW,
    output [4:0]  Rs1D, Rs2D,
    output [4:0]  Rs1E, Rs2E,
    output [4:0]  RdE, RdM, RdW
);
    wire [31:0] PCNextF, PCPlus4F;
    wire [31:0] InstrD, PCD, PCPlus4D;
    wire [31:0] RD1D, RD2D;
    wire [31:0] ImmExtD;
    wire [4:0]  RdD;
    wire [31:0] RD1E, RD2E;
    wire [31:0] PCE, ImmExtE;
    wire [31:0] SrcAE, SrcBE;
    wire [31:0] ALUResultE;
    wire [31:0] WriteDataE;
    wire [31:0] PCPlus4E;
    wire [31:0] PCTargetE;
    wire [31:0] PCPlus4M;
    wire [31:0] ALUResultW, PCPlus4W; // ReadDataW la input, khong khai bao o day nua
    wire [31:0] ResultW;

    mux2    #(32) pcmux    (PCPlus4F, PCTargetE, PCSrcE, PCNextF);
    flopenr #(32) pcreg    (clk, reset, ~StallF, PCNextF, PCF);
    adder         pcadd    (PCF, 32'h4, PCPlus4F);

    flopenrc #(96) regD (clk, reset, ~StallD, FlushD,
        {InstrF, PCF, PCPlus4F},
        {InstrD, PCD, PCPlus4D});

    assign opD       = InstrD[6:0];
    assign funct3D   = InstrD[14:12];
    assign funct7b5D = InstrD[30];
    assign Rs1D      = InstrD[19:15];
    assign Rs2D      = InstrD[24:20];
    assign RdD       = InstrD[11:7];

    regfile rf (clk, RegWriteW, Rs1D, Rs2D, RdW, ResultW, RD1D, RD2D);
    extend  ext (InstrD[31:7], ImmSrcD, ImmExtD);

    floprc #(175) regE (clk, reset, FlushE,
        {RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D},
        {RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E});

    mux3 #(32) faemux  (RD1E, ResultW, ALUResultM, ForwardAE, SrcAE);
    mux3 #(32) fbemux  (RD2E, ResultW, ALUResultM, ForwardBE, WriteDataE);
    mux2 #(32) srcbmux (WriteDataE, ImmExtE, ALUSrcE, SrcBE);
    alu        alu_u   (SrcAE, SrcBE, ALUControlE, ALUResultE, ZeroE);
    adder      branchadd (ImmExtE, PCE, PCTargetE);

    flopr #(101) regM (clk, reset,
        {ALUResultE, WriteDataE, RdE, PCPlus4E},
        {ALUResultM, WritedataM, RdM, PCPlus4M});

    // [FIX 2026-06-07] Bo ReadDataM khoi regW (101 bit → 69 bit).
    // LY DO: dmem da tu register ReadDataW (sync read), neu regW latch them
    // se bi double-latch (data tre them 1 cycle, sai pipeline).
    flopr #(69) regW (clk, reset,
        {ALUResultM, RdM, PCPlus4M},
        {ALUResultW, RdW, PCPlus4W});

    mux3 #(32) resultmux (ALUResultW, ReadDataW, PCPlus4W, ResultSrcW, ResultW);
endmodule
