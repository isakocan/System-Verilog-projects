module immediate_generator (
    input  logic [31:0] Instruction,
    input  logic [2:0]  ImmSrc,
    output logic [31:0] ImmExt
);

    logic        imm_31;
    logic [11:0] imm_31_20;
    logic [6:0]  imm_31_25;
    logic [4:0]  imm_11_7;
    logic        imm_7;
    logic [5:0]  imm_30_25;
    logic [3:0]  imm_11_8;
    logic [19:0] imm_31_12;
    logic [7:0]  imm_19_12;
    logic        imm_20;
    logic [9:0]  imm_30_21;

    assign imm_31    = Instruction[31];
    assign imm_31_20 = Instruction[31:20];
    assign imm_31_25 = Instruction[31:25];
    assign imm_11_7  = Instruction[11:7];
    assign imm_7     = Instruction[7];
    assign imm_30_25 = Instruction[30:25];
    assign imm_11_8  = Instruction[11:8];
    assign imm_31_12 = Instruction[31:12];
    assign imm_19_12 = Instruction[19:12];
    assign imm_20    = Instruction[20];
    assign imm_30_21 = Instruction[30:21];

    always_comb begin
        case (ImmSrc)
            3'b000: ImmExt = {{20{imm_31}}, imm_31_20}; // I-type (LW, ADDI, SLTI, ORI, ANDI, JALR)
            3'b001: ImmExt = {{20{imm_31}}, imm_31_25, imm_11_7}; // S-type (SW)
            3'b010: ImmExt = {{19{imm_31}}, imm_7, imm_30_25, imm_11_8, 1'b0}; // B-type (BEQ)
            3'b011: ImmExt = {{11{imm_31}}, imm_19_12, imm_20, imm_30_21, 1'b0}; // J-type (JAL)
            3'b100: ImmExt = {imm_31_12, 12'b0}; // U-type (LUI)
            default: ImmExt = 32'bx; 
        endcase
    end
endmodule