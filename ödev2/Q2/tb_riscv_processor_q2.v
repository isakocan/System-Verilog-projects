`timescale 1ns / 1ps
`include "riscv_processor.v"

module tb_riscv_processor_q2;

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
        // Test Case 1: Simple shift
        instr_mem[0]  = 32'h00500093; // addi x1, x0, 5     (x1 = 5)
        instr_mem[1]  = 32'h00200113; // addi x2, x0, 2     (x2 = 2)
        instr_mem[2]  = 32'h002091B3; // sll  x3, x1, x2     (x3 = 5 << 2 = 20)

        // Test Case 2: Shift amount > 31
        // x1 = 5
        instr_mem[3]  = 32'h02300213; // addi x4, x0, 35    (x4 = 35)
        instr_mem[4]  = 32'h004092B3; // sll  x5, x1, x4     (x5 = 5 << (35&31)=3 = 40)

        // Test Case 3: Shift result is zero
        instr_mem[5]  = 32'h00000093; // addi x1, x0, 0     (x1 = 0)
        instr_mem[6]  = 32'h00209333; // sll  x6, x1, x2     (x6 = 0 << 2 = 0)

        // Test Case 4: Large shift amount
        instr_mem[7]  = 32'h00100093; // addi x1, x0, 1     (x1 = 1)
        instr_mem[8]  = 32'h01F00113; // addi x2, x0, 31    (x2 = 31)
        instr_mem[9]  = 32'h002093B3; // sll  x7, x1, x2     (x7 = 1 << 31 = 0x80000000)

        $dumpfile("wave_q2.vcd");
        $dumpvars(0, tb_riscv_processor_q2);

        #100;

        $display("Simulasyon tamamlandi!");
        $finish;
    end

endmodule
// iverilog -g2012 -o sim_q2 tb_riscv_processor_q2.v
// vvp sim_q2
// gtkwave wave_q2.vcd &