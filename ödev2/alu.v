module alu (
    input  logic [31:0] A, B,         
    input  logic [2:0]  ALUControl,  
    output logic [31:0] Result,     
    output logic        Zero         
);

    always_comb begin
        case (ALUControl)
            3'b000: Result = A + B;                                     
            3'b001: Result = A - B;                                     
            3'b010: Result = A & B;                                     
            3'b011: Result = A | B;                                     
            3'b101: Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;

            default: Result = 32'bx;
        endcase
    end

    assign Zero = (Result == 32'b0);

endmodule