module imem(
    input  [31:0] a,
    output reg [31:0] rd
);
    // ROM hardcoded - tranh GoWIN khong load ram_init_file cho async ROM
    always @(*) begin
        // [FIX 2026-06-10] Sua case(a[31:2]) thanh case(a[7:2]).
        // LY DO: PC la byte address, word index la a[7:2] (khong phai a[31:2]).
        // Simulation van dung vi PC nho (0,4,8,12) nhung sai ve mat logic.
        case (a[7:2])
            6'd0: rd = 32'h00000093;  // addi x1,x0,0   (PC=0)
            6'd1: rd = 32'h00108093;  // addi x1,x1,1   (PC=4)
            6'd2: rd = 32'h00102023;  // sw x1,0(x0)    (PC=8)  MemWrite=1
            6'd3: rd = 32'hff9ff06f;  // jal x0,-8      (PC=12)
            default: rd = 32'h00000013;  // nop
        endcase
    end
endmodule
