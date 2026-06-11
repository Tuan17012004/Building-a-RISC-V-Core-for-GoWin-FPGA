module regfile(
    input         clk,
    input         we3,
    input  [4:0]  a1, a2, a3,
    input  [31:0] wd3,
    output [31:0] rd1, rd2
);
    reg [31:0] rf[31:0];
    always @(posedge clk)
        if (we3) rf[a3] <= wd3;
    assign rd1 = (a1 != 5'd0) ? rf[a1] : 32'd0;
    assign rd2 = (a2 != 5'd0) ? rf[a2] : 32'd0;
endmodule
