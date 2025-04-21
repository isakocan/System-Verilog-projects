module Mux5x1 #(parameter N = 32) (
    input  wire [N-1:0] In_AddResult,
    input  wire [N-1:0] In_SubResult,
    input  wire [N-1:0] In_AndResult,
    input  wire [N-1:0] In_XorResult,
    input  wire [N-1:0] In_SltResult,
    input  wire [2:0]   Sel,
    output reg [N-1:0] Out
);

    always @(*) begin
        case (Sel)
            3'b000:  Out = In_AddResult;
            3'b001:  Out = In_SubResult;
            3'b010:  Out = In_AndResult;
            3'b011:  Out = In_XorResult;
            3'b101:  Out = In_SltResult;
            default: Out = {N{1'bx}};
        endcase
    end

endmodule