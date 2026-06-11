module mem (
    input        clk, we,
    input  [31:0] a,
    input  [31:0] wd,
    output reg [31:0] rd
);
    // [FIX 2025-06-06] Them initial block cho simulation.
    // LY DO: ram_init_file chi hoat dong khi tong hop Gowin, khong co tac dung
    // trong ModelSim simulation. Them initial block de RAM co chuong trinh
    // ngay khi simulation bat dau (khong can mem load trong sim_run.do).
    // FPGA van dung ram_init_file = "program.mi" nhu cu.
    (* ram_init_file = "program.mi" *)
    reg [31:0] RAM[63:0];
    initial begin
        RAM[0] = 32'h00000093; // addi x1,x0,0   (PC=0, init 1 lan)
        RAM[1] = 32'h00108093; // addi x1,x1,1   (PC=4, vong lap)
        RAM[2] = 32'h00102023; // sw   x1,0(x0)  (PC=8)
        RAM[3] = 32'hff9ff06f; // jal  x0,-8     (PC=12) -> PC=4
    end

    // ==========================================================
    // CHUYEN DOI READ MODE — chon 1 trong 2 khoi ben duoi:
    //
    // [CHE DO 1] SIMULATION (ModelSim) — dang dung
    //   assign rd = RAM[a[31:2]];          // async read
    //   always @(posedge clk)              // posedge write
    //       if (we) RAM[a[31:2]] <= wd;
    //   LY DO: Multicycle FSM tu quan ly timing qua IRWrite.
    //   Neu dung sync read, rd tre 1 chu ky → Instr=x → FSM ket o FETCH/DECODE.
    //
    // [CHE DO 2] FPGA GOWIN (tranh PA2122) — comment lai khi can deploy
    //   always @(negedge clk)              // negedge write
    //       if (we) RAM[a[31:2]] <= wd;
    //   always @(posedge clk)              // posedge sync read
    //       rd <= RAM[a[31:2]];
    //   LY DO: Gowin SDPB BSRAM khong ho tro WRITE_MODE=2'b10.
    //   negedge write + posedge read ep Gowin dung LUT/FF, tranh loi PA2122.
    //   NHUNG lam hong simulation (xem ly do CHE DO 1).
    // ==========================================================

    // [FIX 2026-06-10] Doi ve async read + posedge write (CHE DO 1 — simulation).
    // LY DO: Sync read lam Instr=x, FSM ket o FETCH/DECODE, jal khong nhay.
    always @(posedge clk)
        if (we) RAM[a[31:2]] <= wd;

    assign rd = RAM[a[31:2]];
endmodule
