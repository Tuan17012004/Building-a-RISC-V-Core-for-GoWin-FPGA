module dmem (
    input        clk, we,
    input  [31:0] a,
    input  [31:0] wd,
    output reg [31:0] rd
);
    // [FIX 2026-06-07] Dung negedge write + posedge read.
    // LY DO: Gowin SP BSRAM voi posedge write luon bi infer WRITE_MODE=2'b10
    // (khong ho tro). regfile.sv dung negedge write va khong gap loi nay.
    // negedge write + posedge read dung 2 clock edge khac nhau → Gowin
    // khong infer thanh SP BSRAM → dung LUT/FF, tranh PA2122.
    // Timing van dung: negedge ghi xong truoc posedge M→W tiep theo latch rd.
    reg [31:0] RAM[63:0];

    always @(negedge clk)
        if (we) RAM[a[31:2]] <= wd;

    always @(posedge clk)
        rd <= RAM[a[31:2]];
endmodule
