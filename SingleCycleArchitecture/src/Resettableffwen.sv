module flopenr #(parameter WIDTH = 8)(
    input              clk, reset, en,
    input  [WIDTH-1:0] d,
    (* syn_preserve = "true" *) output reg [WIDTH-1:0] q
);
    always @(posedge clk or posedge reset)
        if (reset)   q <= {WIDTH{1'b0}};
        else if (en) q <= d;
endmodule
