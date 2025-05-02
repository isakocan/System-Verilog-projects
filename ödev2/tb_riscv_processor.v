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
        instr_mem[2]  = 32'h002081B3; // add  x3, x1, x2
        instr_mem[3]  = 32'h40110233; // sub  x4, x2, x1
        instr_mem[4]  = 32'h0020A2B3; // slt  x5, x1, x2
        instr_mem[5]  = 32'h0040E333; // or   x6, x1, x4
        instr_mem[6]  = 32'h0020F3B3; // and  x7, x1, x2
        instr_mem[7]  = 32'hFFB18413; // addi x8, x3, -5
        instr_mem[8]  = 32'h00A22493; // slti x9, x4, 10
        instr_mem[9]  = 32'h05536513; // ori  x10, x6, 0x55
        instr_mem[10] = 32'h00F37593; // andi x11, x6, 0x0F
        instr_mem[11] = 32'h00302423; // sw   x3, 8(x0)
        instr_mem[12] = 32'h00802603; // lw   x12, 8(x0)
        instr_mem[13] = 32'h00408463; // beq  x1, x4, +8 (L1 @ 0x3C)
        instr_mem[14] = 32'h06300693; // addi x13, x0, 99 (Skipped)
        instr_mem[15] = 32'h008000EF; // jal  x1, +8     (L1 -> L2 @ 0x44)
        instr_mem[16] = 32'h05800713; // addi x14, x0, 88 (Skipped, RA=0x40)
        instr_mem[17] = 32'h00200793; // addi x15, x0, 2
        instr_mem[18] = 32'hFFF78793; // LOOP_START: addi x15, x15, -1
        instr_mem[19] = 32'h00078463; // beq  x15, x0, +8 (LOOP_END @ 0x54)
        instr_mem[20] = 32'hFF9FF0EF; // jal  x0, -8    (LOOP_START @ 0x48)
                                      // (LOOP_END)

        $dumpfile("wave_q1.vcd"); 
        $dumpvars(0, tb_riscv_processor); 

        #210; 

        $display("Simulasyon tamamlandi!");
        $finish;
    end
endmodule



// iverilog -g2012 -o sim_q1 tb_riscv_processor.v
// vvp sim_q1
// gtkwave wave_q1.vcd &