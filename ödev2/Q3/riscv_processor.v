`include "alu.v"
`include "control_unit.v" 
`include "data_memory.v"
`include "immediate_generator.v" 
`include "pc_register.v"
`include "register_file.v"

module riscv_processor (
    input  logic        clk,
    input  logic [31:0] Instruction, 
    output logic [31:0] PC_out,      
    output logic [31:0] ALUResult_out,
    output logic [31:0] Mem_ReadData_out,
    output logic [31:0] WriteData_to_RegFile 
);


    logic [31:0] PC_current;
    logic [31:0] PC_next;
    logic [31:0] PC_plus4;
    logic [31:0] PC_target;
    logic        PCSrc;

    logic [6:0] opcode;
    logic [4:0] rs1_addr, rs2_addr, rd_addr;
    logic [2:0] funct3;
    logic       funct7b5;

    logic        RegWrite;
    logic [2:0]  ImmSrc;       // 3 BITS
    logic        ALUSrc;
    logic        MemWrite;
    logic [1:0]  ResultSrc;
    logic        Branch;
    logic        Jump;
    logic [2:0]  ALUControl;

    logic [31:0] ImmExtended;

    logic [31:0] Reg_ReadData1;
    logic [31:0] Reg_ReadData2;
    logic [31:0] Result_WriteData; 

    logic [31:0] ALU_InputA;
    logic [31:0] ALU_InputB;
    logic [31:0] ALU_Result;
    logic        ALU_Zero;

    logic [31:0] Mem_ReadData;


    assign opcode   = Instruction[6:0];
    assign rs1_addr = Instruction[19:15];
    assign rs2_addr = Instruction[24:20];
    assign rd_addr  = Instruction[11:7];
    assign funct3   = Instruction[14:12];
    assign funct7b5 = Instruction[30];


    pc_register pc_reg (
        .clk     (clk),
        .NextPC  (PC_next),
        .PC      (PC_current)
    );

    control_unit ctrl_unit (
        .Opcode    (opcode),
        .funct3    (funct3),
        .funct7b5  (funct7b5),
        .RegWrite  (RegWrite),
        .ImmSrc    (ImmSrc),      // 3 BITS
        .ALUSrc    (ALUSrc),
        .MemWrite  (MemWrite),
        .ResultSrc (ResultSrc),
        .Branch    (Branch),
        .Jump      (Jump),
        .ALUControl(ALUControl)
    );

    register_file reg_file (
        .clk       (clk),
        .RegWrite  (RegWrite),
        .rs1_addr  (rs1_addr),
        .rs2_addr  (rs2_addr),
        .rd_addr   (rd_addr),
        .WriteData (Result_WriteData), // Use the output of the Result Mux
        .ReadData1 (Reg_ReadData1),
        .ReadData2 (Reg_ReadData2)
    );

    immediate_generator imm_gen (
        .Instruction (Instruction),
        .ImmSrc      (ImmSrc),      // 3 BITS
        .ImmExt      (ImmExtended)
    );

    assign ALU_InputA = Reg_ReadData1;
    assign ALU_InputB = ALUSrc ? ImmExtended : Reg_ReadData2;

    alu alu_unit (
        .A          (ALU_InputA),
        .B          (ALU_InputB),
        .ALUControl (ALUControl),
        .Result     (ALU_Result),
        .Zero       (ALU_Zero)
    );

    data_memory data_mem (
        .clk       (clk),
        .MemWrite  (MemWrite),
        .Address   (ALU_Result),
        .WriteData (Reg_ReadData2),
        .ReadData  (Mem_ReadData)
    );

    always_comb begin
        case (ResultSrc)
            2'b00:  Result_WriteData = ALU_Result;    // R-type, I-type ALU
            2'b01:  Result_WriteData = Mem_ReadData;  // lw
            2'b10:  Result_WriteData = PC_plus4;      // jal
            2'b11:  Result_WriteData = ImmExtended;   // lui
            default: Result_WriteData = 32'bx;
        endcase
    end

    assign PC_plus4 = PC_current + 32'd4;
    assign PC_target = PC_current + ImmExtended;
    assign PCSrc = (Branch & ALU_Zero) | Jump;
    assign PC_next = PCSrc ? PC_target : PC_plus4;

    assign PC_out = PC_current;
    assign ALUResult_out = ALU_Result;
    assign Mem_ReadData_out = Mem_ReadData;
    assign WriteData_to_RegFile = Result_WriteData;

endmodule