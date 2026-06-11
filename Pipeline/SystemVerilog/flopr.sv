// [FIX 2026-06-07] Tao moi file nay.
// LY DO: flopr.sv bi thieu trong PipelineArchitecture/src/ khien controller.sv
// va datapath.sv bao loi "Instantiating unknown module 'flopr'" khi Synthesize.
// Module flopr: D flip-flop co async reset, dung lam pipeline register tang M va W.
module flopr #(parameter WIDTH = 8) (
    input              clk, reset,
    input  [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk or posedge reset)
        if (reset) q <= {WIDTH{1'b0}};
        else       q <= d;
endmodule
