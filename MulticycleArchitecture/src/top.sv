module top (
    input        clk, reset,
    output [31:0] WriteData, Adr,
    output        MemWrite
);
    wire [31:0] ReadData;

    riscv rvcore (
        .clk(clk), .reset(reset),
        .Adr(Adr), .WriteData(WriteData),
        .ReadData(ReadData),
        .MemWrite(MemWrite)
    );

    mem m (
        .clk(clk), .we(MemWrite),
        .a(Adr), .wd(WriteData),
        .rd(ReadData)
    );
endmodule
