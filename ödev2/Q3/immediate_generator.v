module immediate_generator (
    input  logic [31:0] Instruction,
    input  logic [1:0]  ImmSrc,
    output logic [31:0] ImmExt
);

    localparam I_TYPE = 2'b00;
    localparam S_TYPE = 2'b01;
    localparam B_TYPE = 2'b10;
    localparam J_TYPE = 2'b11;

    logic [31:0] imm_i_ext, imm_s_ext, imm_b_ext, imm_j_ext;
    logic [12:0] imm_b_val;
    logic [20:0] imm_j_val; 

    // I-type
    assign imm_i_ext = {{20{Instruction[31]}}, Instruction[31:20]};

    // S-type
    assign imm_s_ext = {{20{Instruction[31]}}, Instruction[31:25], Instruction[11:7]};

    // B-type
    assign imm_b_val = {Instruction[31], Instruction[7], Instruction[30:25], Instruction[11:8], 1'b0};
    assign imm_b_ext = {{19{imm_b_val[12]}}, imm_b_val};

    // J-type 
    assign imm_j_val = {Instruction[31], Instruction[19:12], Instruction[20], Instruction[30:21], 1'b0};
    assign imm_j_ext = {{11{imm_j_val[20]}}, imm_j_val};


    always_comb begin
        case (ImmSrc)
            I_TYPE:  ImmExt = imm_i_ext;
            S_TYPE:  ImmExt = imm_s_ext;
            B_TYPE:  ImmExt = imm_b_ext;
            J_TYPE:  ImmExt = imm_j_ext;
            default: ImmExt = 32'bx; 
        endcase
    end

endmodule