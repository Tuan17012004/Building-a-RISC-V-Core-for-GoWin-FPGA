module pc(
    input         clk, reset,
    input  [31:0] pcnext,
    output reg [31:0] pc_out
);
    always @(posedge clk or posedge reset)
        if (reset) pc_out <= 32'h00000000;
        else       pc_out <= pcnext;
endmodule
