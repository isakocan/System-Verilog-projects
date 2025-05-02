module control_unit (
    input  logic [6:0] Opcode,
    input  logic [2:0] funct3,
    input  logic       funct7b5,

    output logic       RegWrite,
    output logic [1:0] ImmSrc,
    output logic       ALUSrc,
    output logic       MemWrite,
    output logic [1:0] ResultSrc,
    output logic       Branch,
    output logic       Jump,
    output logic [2:0] ALUControl
);

    logic [1:0] ALUOp;

    localparam LW   = 7'b0000011;
    localparam SW   = 7'b0100011;
    localparam RTYPE = 7'b0110011;
    localparam BEQ  = 7'b1100011;
    localparam ITYPE_ALU = 7'b0010011;
    localparam JAL  = 7'b1101111;

    always_comb begin

        RegWrite  = 1'b0; ImmSrc    = 2'bxx; ALUSrc    = 1'b0;
        MemWrite  = 1'b0; ResultSrc = 2'bxx; Branch    = 1'b0;
        ALUOp     = 2'bxx; Jump      = 1'b0;

        case (Opcode)
            LW: begin
                RegWrite  = 1'b1; ImmSrc = 2'b00; ALUSrc = 1'b1; MemWrite = 1'b0; ResultSrc = 2'b01; Branch = 1'b0; ALUOp = 2'b00; Jump = 1'b0;
            end
            SW: begin
                RegWrite  = 1'b0; ImmSrc = 2'b01; ALUSrc = 1'b1; MemWrite = 1'b1; ResultSrc = 2'bxx; Branch = 1'b0; ALUOp = 2'b00; Jump = 1'b0;
            end
            RTYPE: begin // Covers add, sub, slt, or, and, SLL
                RegWrite  = 1'b1; ImmSrc = 2'bxx; ALUSrc = 1'b0; MemWrite = 1'b0; ResultSrc = 2'b00; Branch = 1'b0; ALUOp = 2'b10; Jump = 1'b0;
            end
            BEQ: begin
                RegWrite  = 1'b0; ImmSrc = 2'b10; ALUSrc = 1'b0; MemWrite = 1'b0; ResultSrc = 2'bxx; Branch = 1'b1; ALUOp = 2'b01; Jump = 1'b0;
            end
            ITYPE_ALU: begin // Covers addi, slti, ori, andi
                RegWrite  = 1'b1; ImmSrc = 2'b00; ALUSrc = 1'b1; MemWrite = 1'b0; ResultSrc = 2'b00; Branch = 1'b0; ALUOp = 2'b10; Jump = 1'b0;
            end
            JAL: begin
                RegWrite  = 1'b1; ImmSrc = 2'b11; ALUSrc = 1'bx; MemWrite = 1'b0; ResultSrc = 2'b10; Branch = 1'b0; ALUOp = 2'bxx; Jump = 1'b1;
            end
            default: begin 
                RegWrite  = 1'b0; ImmSrc = 2'bxx; ALUSrc = 1'b0;
                MemWrite  = 1'b0; ResultSrc = 2'bxx; Branch = 1'b0;
                ALUOp     = 2'bxx; Jump      = 1'b0;
            end
        endcase
    end


    always_comb begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000;
            2'b01: ALUControl = 3'b001;
            2'b10: begin // R-type or I-type ALU operation
                case (funct3)
                    3'b000: begin // add, sub, addi
                        if (funct7b5 == 1'b1 && Opcode == RTYPE)
                            ALUControl = 3'b001; // SUB
                        else
                            ALUControl = 3'b000; // ADD or ADDI
                    end
                    3'b001: ALUControl = 3'b100; // <<< NEW: SLL (funct3 = 001 for R-Type)
                    3'b010: ALUControl = 3'b101; // slt, slti
                    3'b110: ALUControl = 3'b011; // or, ori
                    3'b111: ALUControl = 3'b010; // and, andi
                    default: ALUControl = 3'bxxx;
                endcase
            end
            default: ALUControl = 3'bxxx;
        endcase
    end

endmodule