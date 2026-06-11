module floprc #(parameter WIDTH = 8)(
    input              clk,
    input              reset,
    input              clear,
    input  [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk or posedge reset)
        if (reset)
            q <= {WIDTH{1'b0}};
        else if (clear)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
endmodule
