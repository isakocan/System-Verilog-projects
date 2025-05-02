`timescale 1ns / 1ps
`include "riscv_processor.v" 

module tb_riscv_processor_q3;

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
        instr_mem[0] = 32'hABCDE2B7; // lui x5, 0xABCDE (x5 = ABCDE000)
        instr_mem[1] = 32'h00001337; // lui x6, 0x1 (x6 = 00001000)
        instr_mem[2] = 32'hFFFFF3B7; // lui x7, 0xFFFFF (x7 = FFFFF000)
        instr_mem[3] = 32'h12328293; // addi x5, x5, 0x123 (x5 = ABCDE123)
        instr_mem[4] = 32'h00130313; // addi x6, x6, 1 (x6 = 00001001)
        instr_mem[5] = 32'hFFF38393; // addi x7, x7, 0xFFF (x7 = FFFFFFFF)

        $dumpfile("wave_q3.vcd");
        $dumpvars(0, tb_riscv_processor_q3);

        #60;
        $display("Simulasyon tamamlandi!");
        $finish;
    end

endmodule

// iverilog -g2012 -o sim_q3 tb_riscv_processor_q3.v
// vvp sim_q3
// gtkwave wave_q3.vcd &