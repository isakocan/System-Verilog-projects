module control_unit (
    input  logic [6:0] Opcode,
    input  logic [2:0] funct3,
    input  logic       funct7b5, 

    output logic       RegWrite,
    output logic [2:0] ImmSrc,      // <<< 3 BITS
    output logic       ALUSrc,
    output logic       MemWrite,
    output logic [1:0] ResultSrc,
    output logic       Branch,
    output logic       Jump,        
    output logic [2:0] ALUControl   
);

    logic [1:0] ALUOp;

    // Opcodes
    localparam LW   = 7'b0000011;
    localparam SW   = 7'b0100011;
    localparam RTYPE = 7'b0110011; // add, sub, slt, or, and, sll
    localparam BEQ  = 7'b1100011;
    localparam ITYPE_ALU = 7'b0010011; // addi, slti, ori, andi
    localparam JAL  = 7'b1101111;
    localparam LUI  = 7'b0110111; // <<< NEW OPCODE


    always_comb begin

        RegWrite  = 1'b0; ImmSrc    = 3'bxxx; ALUSrc    = 1'b0;
        MemWrite  = 1'b0; ResultSrc = 2'bxx; Branch    = 1'b0;
        ALUOp     = 2'bxx; Jump      = 1'b0;

        case (Opcode)
            LW: begin
                RegWrite  = 1'b1; ImmSrc = 3'b000; ALUSrc = 1'b1; MemWrite = 1'b0; ResultSrc = 2'b01; Branch = 1'b0; ALUOp = 2'b00; Jump = 1'b0; // ImmSrc=I-type
            end
            SW: begin
                RegWrite  = 1'b0; ImmSrc = 3'b001; ALUSrc = 1'b1; MemWrite = 1'b1; ResultSrc = 2'bxx; Branch = 1'b0; ALUOp = 2'b00; Jump = 1'b0; // ImmSrc=S-type
            end
            RTYPE: begin // Covers add, sub, slt, or, and, sll
                RegWrite  = 1'b1; ImmSrc = 3'bxxx; ALUSrc = 1'b0; MemWrite = 1'b0; ResultSrc = 2'b00; Branch = 1'b0; ALUOp = 2'b10; Jump = 1'b0; // ImmSrc=don't care
            end
            BEQ: begin
                RegWrite  = 1'b0; ImmSrc = 3'b010; ALUSrc = 1'b0; MemWrite = 1'b0; ResultSrc = 2'bxx; Branch = 1'b1; ALUOp = 2'b01; Jump = 1'b0; // ImmSrc=B-type
            end
            ITYPE_ALU: begin // Covers addi, slti, ori, andi
                RegWrite  = 1'b1; ImmSrc = 3'b000; ALUSrc = 1'b1; MemWrite = 1'b0; ResultSrc = 2'b00; Branch = 1'b0; ALUOp = 2'b10; Jump = 1'b0; // ImmSrc=I-type
            end
            JAL: begin
                RegWrite  = 1'b1; ImmSrc = 3'b011; ALUSrc = 1'bx; MemWrite = 1'b0; ResultSrc = 2'b10; Branch = 1'b0; ALUOp = 2'bxx; Jump = 1'b1; // ImmSrc=J-type, ResultSrc=PC+4
            end
            LUI: begin // <<< NEW CASE for LUI
                RegWrite  = 1'b1; ImmSrc = 3'b100; ALUSrc = 1'bx; MemWrite = 1'b0; ResultSrc = 2'b11; Branch = 1'b0; ALUOp = 2'bxx; Jump = 1'b0; // ImmSrc=U-type, ResultSrc=ImmExt
            end
            default: begin 
                RegWrite  = 1'b0; ImmSrc = 3'bxxx; ALUSrc = 1'b0;
                MemWrite  = 1'b0; ResultSrc = 2'bxx; Branch = 1'b0;
                ALUOp     = 2'bxx; Jump      = 1'b0;
            end
        endcase
    end


    always_comb begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000;
            2'b01: ALUControl = 3'b001; 
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if (Opcode == RTYPE && funct7b5 == 1'b1)
                            ALUControl = 3'b001; 
                        else
                            ALUControl = 3'b000; 
                    end
                    3'b001: ALUControl = 3'b100; 
                    3'b010: ALUControl = 3'b101; 
                    3'b110: ALUControl = 3'b011; 
                    3'b111: ALUControl = 3'b010; 
                    default: ALUControl = 3'bxxx;
                endcase
            end
            default: ALUControl = 3'bxxx;
        endcase
    end

endmodule