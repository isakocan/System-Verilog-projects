`include "alu.v"
`timescale 1ns/1ps

module ALU_tb;

    localparam N = 32;

    reg [N-1:0] tb_A;
    reg [N-1:0] tb_B;
    reg [2:0]   tb_ALUControl;
    wire [N-1:0] tb_Result;
    wire         tb_oVerflow;


    ALU #(.N(N)) uut (
        .A(tb_A),
        .B(tb_B),
        .ALUControl(tb_ALUControl),
        .Result(tb_Result),
        .oVerflow(tb_oVerflow)
    );


    initial begin

        $dumpfile("alu_tb.vcd");
        $dumpvars(0, ALU_tb);

        tb_A = 32'b0;
        tb_B = 32'b0;
        tb_ALUControl = 3'b000;
        #5;


        $display("--- ADD Testleri (000) ---");
        tb_ALUControl = 3'b000;
        tb_A = 32'd10;      tb_B = 32'd5;      #10;
        tb_A = 32'd10;      tb_B = 32'hFFFF_FFFB;  #10;
        tb_A = 32'hFFFF_FFF6;  tb_B = 32'd5;      #10;
        tb_A = 32'hFFFF_FFF6;  tb_B = 32'hFFFF_FFFB;  #10;

        tb_A = 32'h7FFFFFFF;tb_B = 32'd1;      #10;
        tb_A = 32'h80000000;tb_B = 32'h80000000;#10;

        $display("--- SUB Testleri (001) ---");
        tb_ALUControl = 3'b001;
        tb_A = 32'd10;      tb_B = 32'd5;      #10;
        tb_A = 32'd5;       tb_B = 32'd10;     #10;
        tb_A = 32'd10;      tb_B = 32'hFFFF_FFFB;  #10;
        tb_A = 32'hFFFF_FFF6;  tb_B = 32'd5;      #10;
        tb_A = 32'hFFFF_FFF6;  tb_B = 32'hFFFF_FFFB;  #10;

        tb_A = 32'h7FFFFFFF;tb_B = 32'hFFFFFFFF;#10;
        tb_A = 32'h80000000;tb_B = 32'd1;      #10;

        $display("--- AND Testleri (010) ---");
        tb_ALUControl = 3'b010;
        tb_A = 32'hFFFF0000;tb_B = 32'h0000FFFF;#10;
        tb_A = 32'hF0F0F0F0;tb_B = 32'h0F0F0F0F;#10;
        tb_A = 32'hABCDEF01;tb_B = 32'hFFFFFFFF;#10;

        $display("--- XOR Testleri (011) ---");
        tb_ALUControl = 3'b011;
        tb_A = 32'hFFFF0000;tb_B = 32'h0000FFFF;#10;
        tb_A = 32'hF0F0F0F0;tb_B = 32'h0F0F0F0F;#10;
        tb_A = 32'hABCDEF01;tb_B = 32'hFFFFFFFF;#10;
        tb_A = 32'd10;      tb_B = 32'd10;     #10;

        $display("--- SLT Testleri (101) ---");
        tb_ALUControl = 3'b101;
        tb_A = 32'd5;       tb_B = 32'd10;     #10;
        tb_A = 32'd10;      tb_B = 32'd5;      #10;
        tb_A = 32'hFFFF_FFFB;  tb_B = 32'd10;     #10;
        tb_A = 32'd5;       tb_B = 32'hFFFF_FFF6; #10;
        tb_A = 32'hFFFF_FFF6;  tb_B = 32'hFFFF_FFFB;  #10;
        tb_A = 32'hFFFF_FFFB;   tb_B = 32'hFFFF_FFF6; #10;
        tb_A = 32'd10;      tb_B = 32'd10;     #10;

        tb_A = 32'h80000000;tb_B = 32'h7FFFFFFF;#10;
        tb_A = 32'h7FFFFFFF;tb_B = 32'h80000000;#10;

        $display("--- Tanımsız Kontrol Kodu Testleri ---");
        tb_ALUControl = 3'b100; #10;
        tb_ALUControl = 3'b110; #10;
        tb_ALUControl = 3'b111; #10;

        #20;
        $display("--- Simülasyon Bitti ---");
        $finish;

    end

endmodule