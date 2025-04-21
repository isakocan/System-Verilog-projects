`timescale 1ns/1ps
`define WORD_SIZE 32
`include "datapath.v"

module datapath_tb_2b;

    reg                         tb_Clk;
    reg                         tb_Rst;
    reg [1:0]                   tb_RegReadAddr1;
    reg [1:0]                   tb_RegReadAddr2;
    reg [1:0]                   tb_RegWriteAddr;
    reg                         tb_RegWriteEnable;
    reg [2:0]                   tb_ALUControl;

    datapath dut (
        .Clk(tb_Clk),
        .Rst(tb_Rst),
        .RegReadAddr1(tb_RegReadAddr1),
        .RegReadAddr2(tb_RegReadAddr2),
        .RegWriteAddr(tb_RegWriteAddr),
        .RegWriteEnable(tb_RegWriteEnable),
        .ALUControl(tb_ALUControl)
    );

    always #5 tb_Clk = ~tb_Clk;

    initial begin
        $dumpfile("datapath_tb_2b.vcd");
        $dumpvars(0, datapath_tb_2b);

        tb_Rst = 1'b0;
        tb_RegWriteEnable = 1'b0;
        tb_Clk = 1'b0;

        $display("--- Hedef 1: R1 <- 0 (R0 XOR R0) ---");
        tb_RegReadAddr1 = 2'b00;
        tb_RegReadAddr2 = 2'b00;
        tb_ALUControl = 3'b011;
        tb_RegWriteAddr = 2'b01;
        tb_RegWriteEnable = 1'b1;
        #10;
        tb_RegWriteEnable = 1'b0;

        $display("--- Hedef 2: R0 <- -1 (R2 + R1) ---");
        tb_RegReadAddr1 = 2'b10;
        tb_RegReadAddr2 = 2'b01;
        tb_ALUControl = 3'b000;
        tb_RegWriteAddr = 2'b00;
        tb_RegWriteEnable = 1'b1;
        #10;
        tb_RegWriteEnable = 1'b0;

        $display("--- Hedef 3: R2 <- R1 - 1 (R1 - R3) ---");
        tb_RegReadAddr1 = 2'b01;
        tb_RegReadAddr2 = 2'b11;
        tb_ALUControl = 3'b001;
        tb_RegWriteAddr = 2'b10;
        tb_RegWriteEnable = 1'b1;
        #10;
        tb_RegWriteEnable = 1'b0;

        $display("--- Hedef 4: R3 <- R0 + 1 (R0 - R3) ---");
        tb_RegReadAddr1 = 2'b00;
        tb_RegReadAddr2 = 2'b11;
        tb_ALUControl = 3'b000;
        tb_RegWriteAddr = 2'b11;
        tb_RegWriteEnable = 1'b1;
        #5;
        tb_RegWriteEnable = 1'b0;
        #5
        
        $display("--- Simülasyon Bitti ---");
        $finish;

    end

endmodule