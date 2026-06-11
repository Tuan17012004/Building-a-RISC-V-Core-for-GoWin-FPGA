module imem (
    input  [31:0] a,
    output reg [31:0] rd
);
    // [FIX 2026-06-07] Doi tu BSRAM sang combinatorial ROM (case statement).
    // LY DO: Gowin SP BSRAM voi async read bi infer WRITE_MODE=2'b10 du
    // khong co write port. ram_init_file ep dung BSRAM → loi PA2122.
    // Case statement = combinatorial ROM dung LUT, tranh BSRAM hoan toan.
    // program.mi khong con duoc dung khi synthesis (chuong trinh nam trong LUT).
    // Simulation va FPGA deu dung cung case statement nay.
    // [FIX 2026-06-10] Them lenh init addi x1,x0,0 vao PC=0, doi jal nhay ve PC=4.
    // LY DO: Thieu lenh khoi tao x1=0 → x1 bat dau bang gia tri rac tu regfile.
    // jal cu nhay ve PC=0 (lap lai init) → sua thanh PC=4 de vong lap dung.
    // Chuong trinh 4 lenh giong SingleCycle va Multicycle.
    always @(*) begin
        case (a[7:2])
            6'd0: rd = 32'h00000093; // addi x1,x0,0   (PC=0,  init x1=0, chay 1 lan)
            6'd1: rd = 32'h00108093; // addi x1,x1,1   (PC=4,  vong lap: x1++)
            6'd2: rd = 32'h00102023; // sw   x1,0(x0)  (PC=8,  ghi x1 vao RAM[0])
            6'd3: rd = 32'hff9ff06f; // jal  x0,-8     (PC=12, nhay ve PC=4)
            default: rd = 32'h00000013; // nop
        endcase
    end
endmodule
