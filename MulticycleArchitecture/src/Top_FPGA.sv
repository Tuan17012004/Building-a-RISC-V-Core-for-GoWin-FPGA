module top_fpga(
    input        clk,
    input        rst_n,
    output [3:0] led
);
    // Debounce rst_n: 3 FF dong bo
    reg [2:0] rst_sync;
    always @(posedge clk)
        rst_sync <= {rst_sync[1:0], ~rst_n};
    wire reset = rst_sync[2];

    wire [31:0] WriteData, Adr;
    wire        MemWrite;
    reg  [25:0] div;
    (* syn_preserve = "true" *) reg [3:0] wr_latch;
    (* syn_preserve = "true" *) reg [3:0] wr_display;

    top multicycle_cpu (
        .clk(clk), .reset(reset),
        .WriteData(WriteData), .Adr(Adr), .MemWrite(MemWrite)
    );

    // Chu ky = 50_000_076 clock (~1 giay tai 50 MHz).
    // Moi lenh (addi, sw, jal) mat 4 trang thai FSM: tong 12 chu ky/vong lap.
    // 50_000_076 / 12 = 4_166_673 vong/giay; 4_166_673 mod 16 = 1
    // => LED tang dung 1 moi giay (0->1->2->...->15->0)
    // Neu dung 50_000_000: 50_000_000/12 = 4_166_666 vong, mod 16 = 10 => LED nhay sai
    always @(posedge clk or posedge reset)
        if (reset || div == 26'd50_000_075)
            div <= 26'b0;
        else
            div <= div + 1'b1;

    always @(posedge clk or posedge reset)
        if (reset) wr_latch <= 4'b0;
        else if (MemWrite) wr_latch <= WriteData[3:0];

    always @(posedge clk or posedge reset)
        if (reset) wr_display <= 4'b0;
        else if (div == 26'd50_000_075)
            wr_display <= wr_latch;

    assign led = wr_display;
endmodule
