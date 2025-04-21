`timescale 1ns/1ps
`define WORD_SIZE 32
`include "datapath.v"

module datapath_tb_2a;

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
        $dumpfile("datapath_tb_2a.vcd");
        $dumpvars(0, datapath_tb_2a);

        tb_Rst = 1'b0;
        tb_RegWriteEnable = 1'b0;
        tb_Clk = 1'b0;


        $display("--- Komut 1: R0 <- R1 + R2 ---");
        tb_RegReadAddr1 = 2'b01;
        tb_RegReadAddr2 = 2'b10;
        tb_ALUControl = 3'b000;
        tb_RegWriteAddr = 2'b00;
        tb_RegWriteEnable = 1'b1;
        #10
        tb_RegWriteEnable = 1'b0;


        $display("--- Komut 2: R1 <- R2 AND R3 ---");
        tb_RegReadAddr1 = 2'b10;
        tb_RegReadAddr2 = 2'b11;
        tb_ALUControl = 3'b010;
        tb_RegWriteAddr = 2'b01;
        tb_RegWriteEnable = 1'b1;
        #10
        tb_RegWriteEnable = 1'b0;


        $display("--- Komut 3: R3 <- R2 XOR R0 ---");
        tb_RegReadAddr1 = 2'b10;
        tb_RegReadAddr2 = 2'b00;
        tb_ALUControl = 3'b011;
        tb_RegWriteAddr = 2'b11;
        tb_RegWriteEnable = 1'b1;
        #10
        tb_RegWriteEnable = 1'b0;

        $display("--- Komut 4: R2 <- R1 - R3 ---");
        tb_RegReadAddr1 = 2'b01;
        tb_RegReadAddr2 = 2'b11;
        tb_ALUControl = 3'b001;
        tb_RegWriteAddr = 2'b10;
        tb_RegWriteEnable = 1'b1;
        #10
        tb_RegWriteEnable = 1'b0;

        

        $display("--- Simulasyon Bitti ---");
        $finish;

    end

endmodule