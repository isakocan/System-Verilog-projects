`include "regfile.v"
`include "alu.v"
`define WORD_SIZE 32

module datapath (
    input wire         Clk,
    input wire         Rst,
    
    input wire [1:0]   RegReadAddr1,
    input wire [1:0]   RegReadAddr2,
    input wire [1:0]   RegWriteAddr,
    input wire         RegWriteEnable, 
    input wire [2:0]   ALUControl     

);


    wire [`WORD_SIZE-1:0] rf_ReadData1;
    wire [`WORD_SIZE-1:0] rf_ReadData2;
    wire [`WORD_SIZE-1:0] alu_Result;
    wire                  alu_oVerflow;


    regfile rf_unit (
        .clk(Clk),
        .rst(Rst),
        .wr(RegWriteEnable),
        .addr1(RegReadAddr1),
        .addr2(RegReadAddr2),
        .addr3(RegWriteAddr),
        .data3(alu_Result), 
        .data1(rf_ReadData1),
        .data2(rf_ReadData2)
    );



    ALU #(.N(`WORD_SIZE)) alu_unit (
        .A(rf_ReadData1),      
        .B(rf_ReadData2),      
        .ALUControl(ALUControl),
        .Result(alu_Result),
        .oVerflow(alu_oVerflow)
    );


endmodule