module alu (
    input  logic [31:0] A, B,
    input  logic [2:0]  ALUControl,
    output logic [31:0] Result,
    output logic        Zero
);

    logic [4:0] shift_amount; 
    assign shift_amount = B[4:0];

    always_comb begin
        case (ALUControl)
            3'b000: Result = A + B;                                     // ADD (for L/S, add, addi)
            3'b001: Result = A - B;                                     // SUB (for beq, sub)
            3'b010: Result = A & B;                                     // AND (for and, andi)
            3'b011: Result = A | B;                                     // OR  (for or, ori)
            3'b100: Result = A << shift_amount;                               // <<< NEW: SLL
            3'b101: Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // SLT (for slt, slti)
            default: Result = 32'bx;
        endcase
    end

    assign Zero = (Result == 32'b0);

endmodule