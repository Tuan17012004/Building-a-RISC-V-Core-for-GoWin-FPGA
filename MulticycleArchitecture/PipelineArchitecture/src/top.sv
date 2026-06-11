module top(
    input        clk, reset,
    output [31:0] WriteDataM, DataAdrM,
    output        MemWriteM
);
    // [FIX 2026-06-07] Doi ReadDataM → ReadDataW (dmem sync read output = W-stage data).
    wire [31:0] PCF, InstrF, ReadDataW;

    riscv riscv (
        clk, reset,
        PCF, InstrF,
        MemWriteM, DataAdrM, WriteDataM, ReadDataW
    );

    imem imem (PCF, InstrF);
    dmem dmem (clk, MemWriteM, DataAdrM, WriteDataM, ReadDataW);
endmodule
