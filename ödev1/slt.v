module SLT #(parameter N = 32) (
    input  wire Sum_MSB,
    input  wire Overflow,
    output wire [N-1:0] SLT_Result
);

    wire slt_bit;
    assign slt_bit = Sum_MSB ^ Overflow;

    assign SLT_Result = {{(N-1){1'b0}}, slt_bit};

endmodule