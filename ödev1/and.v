module AND #(parameter N = 32) (
    input  wire [N-1:0] A,
    input  wire [N-1:0] B,
    output wire [N-1:0] Result
);

    assign Result = A & B;

endmodule