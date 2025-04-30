`timescale 1ns / 1ps
`include "riscv_processor.v"

module tb_riscv_processor;
    logic clk;
    logic [31:0] instruction_in;
    logic [31:0] pc_out;
    logic [31:0] alu_result_out;
    logic [31:0] mem_read_data_out;

    logic [31:0] instr_mem [0:63];

    riscv_processor dut (
        .clk          (clk),
        .Instruction  (instruction_in),
        .PC_out       (pc_out),
        .ALUResult_out(alu_result_out),
        .Mem_ReadData_out(mem_read_data_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    assign instruction_in = instr_mem[pc_out >> 2];

    initial begin
        instr_mem[0]  = 32'h00A00093; // addi x1, x0, 10
        instr_mem[1]  = 32'h01400113; // addi x2, x0, 20
        instr_mem[2]  = 32'h00A00193; // addi x3, x0, 10
        instr_mem[3]  = 32'h00208233; // add  x4, x1, x2
        instr_mem[4]  = 32'h401102B3; // sub  x5, x2, x1
        instr_mem[5]  = 32'h0020A333; // slt  x6, x1, x2
        instr_mem[6]  = 32'h0050E3B3; // or   x7, x1, x5
        instr_mem[7]  = 32'h0020F433; // and  x8, x1, x2
        instr_mem[8]  = 32'hFFB20493; // addi x9, x4, -5
        instr_mem[9]  = 32'h00A2A513; // slti x10, x5, 10
        instr_mem[10] = 32'h0553E593; // ori  x11, x7, 0x55
        instr_mem[11] = 32'h00F3F613; // andi x12, x7, 0x0F
        instr_mem[12] = 32'h00402423; // sw   x4, 8(x0)
        instr_mem[13] = 32'h00800683; // lw   x13, 8(x0)
        instr_mem[14] = 32'h00308663; // beq  x1, x3, +12 (L1 @ 0x44 = index 17)
        instr_mem[15] = 32'h06300713; // addi x14, x0, 99  (Skipped)
        instr_mem[16] = 32'h06300793; // addi x15, x0, 99  (Skipped)
        instr_mem[17] = 32'h00008833; // add  x16, x1, x0  (L1)
        instr_mem[18] = 32'h008000EF; // jal  x1, +8     (L2 @ 0x50 = index 20)
        instr_mem[19] = 32'h05800893; // addi x17, x0, 88  (Skipped)
        instr_mem[20] = 32'h04D00913; // addi x18, x0, 77  (L2)
        instr_mem[21] = 32'h00000063; // beq  x0, x0, 0   (loop)

        $dumpfile("wave_q1.vcd"); // VCD dosyasının adı
        $dumpvars(0, tb_riscv_processor); // Tüm sinyalleri dök

        #200; 

        $display("Simulasyon tamamlandi!");
        $finish;
    end
endmodule



// iverilog -g2012 -o sim_q1 tb_riscv_processor.v
// vvp sim_q1
// gtkwave wave_q1.vcd &