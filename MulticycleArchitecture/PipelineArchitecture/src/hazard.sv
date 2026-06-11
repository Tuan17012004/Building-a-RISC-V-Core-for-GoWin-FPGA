module hazard (
    input  [4:0] Rs1D, Rs2D,
    input  [4:0] Rs1E, Rs2E,
    input  [4:0] RdE, RdM, RdW,
    input        PCSrcE,
    input        ResultSrcEb0,
    input        RegWriteM, RegWriteW,
    output reg [1:0] ForwardAE, ForwardBE,
    output       StallF, StallD,
    output       FlushD, FlushE
);
    wire lwStallD;

    always @(*) begin
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
        if (Rs1E != 5'b0)
            if (Rs1E == RdM && RegWriteM)
                ForwardAE = 2'b10;
            else if (Rs1E == RdW && RegWriteW)
                ForwardAE = 2'b01;
        if (Rs2E != 5'b0)
            if (Rs2E == RdM && RegWriteM)
                ForwardBE = 2'b10;
            else if (Rs2E == RdW && RegWriteW)
                ForwardBE = 2'b01;
    end

    assign lwStallD = ResultSrcEb0 & ((Rs1D == RdE) | (Rs2D == RdE));
    assign StallD   = lwStallD;
    assign StallF   = lwStallD;
    assign FlushD   = PCSrcE;
    assign FlushE   = lwStallD | PCSrcE;
endmodule
