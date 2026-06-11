module top_fpga(input clk, input rst_n, output [3:0] led);
    // Debounce rst_n: can 3 FF dong bo
    reg [2:0] rst_sync;
    always @(posedge clk)
        rst_sync <= {rst_sync[1:0], ~rst_n};
    wire reset = rst_sync[2];

    wire [31:0] PC;
    (* syn_keep = "true" *) wire [31:0] Instr;
    (* syn_keep = "true" *) wire        MemWrite;
    (* syn_keep = "true" *) wire [31:0] WriteData;
    wire [31:0] ALUResult, ReadData;
    reg  [25:0] div;
    (* syn_preserve = "true" *) reg [3:0] wr_latch;
    (* syn_preserve = "true" *) reg [3:0] wr_display;

    riscvsingle cpu (.clk(clk),.reset(reset),.PC(PC),.Instr(Instr),
        .MemWrite(MemWrite),.ALUResult(ALUResult),
        .WriteData(WriteData),.ReadData(ReadData));
    imem imem (.a(PC),.rd(Instr));
    dmem dmem (.clk(clk),.we(MemWrite),.a(ALUResult),.wd(WriteData),.rd(ReadData));

    // Chu ky = 50_000_019 clock (≈1 giay tai 50 MHz).
    // Moi giay CPU chay duoc: 50_000_019 / 3 = 16_666_673 vong lap (3 lenh/vong: addi, sw, jal)
    // => x1 tang them: 16_666_673 mod 16 = 1 => LED tang dung 1 moi giay (0->1->2->...->15->0)
    // Neu dung 49_999_999 (50_000_000 chu ky): 50_000_000/3 = 16_666_666 vong,
    //   16_666_666 mod 16 = 10 => LED tang 10 moi buoc => chu ky 3 buoc lap lai (0101, 1010, 1111)
    always @(posedge clk or posedge reset)
        if (reset || div == 26'd50_000_018)
            div <= 26'b0;
        else
            div <= div + 1'b1;

    always @(posedge clk or posedge reset)
        if (reset) wr_latch <= 4'b0;
        else if (MemWrite) wr_latch <= WriteData[3:0];

    always @(posedge clk or posedge reset)
        if (reset) wr_display <= 4'b0;
        else if (div == 26'd50_000_018)
            wr_display <= wr_latch;

    assign led = wr_display;
endmodule
