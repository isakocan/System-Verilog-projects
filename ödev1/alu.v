`include "adder.v"
`include "and.v"
`include "xor.v"
`include "slt.v"
`include "mux5x1.v"

module ALU #(parameter N = 32) (
    input  wire [N-1:0] A,
    input  wire [N-1:0] B,
    input  wire [2:0]   ALUControl,
    output wire [N-1:0] Result,
    output wire         oVerflow
);

    wire [N-1:0] B_operand;
    wire         Cin;
    wire [N-1:0] adder_sum;
    wire         adder_cout;
    wire [N-1:0] and_result;
    wire [N-1:0] xor_result;
    wire [N-1:0] slt_result;


    assign B_operand = B ^ {N{ALUControl[0]}};
    assign Cin = ALUControl[0];


    Adder #(.N(N)) adder_unit (
        .A(A),
        .B(B_operand),
        .Cin(Cin),
        .Sum(adder_sum),
        .Cout(adder_cout)
    );


    assign oVerflow = (~(A[N-1] ^ B[N-1] ^ ALUControl[0])) & (A[N-1] ^ adder_sum[N-1]) & (~ALUControl[1]);


    AND #(.N(N)) and_unit (
        .A(A),
        .B(B),
        .Result(and_result)
    );


    XOR #(.N(N)) xor_unit (
        .A(A),
        .B(B),
        .Result(xor_result)
    );


    SLT #(.N(N)) slt_unit (
        .Sum_MSB(adder_sum[N-1]),
        .Overflow(oVerflow),
        .SLT_Result(slt_result)
    );


    Mux5x1 #(.N(N)) output_mux (
        .In_AddResult(adder_sum),
        .In_SubResult(adder_sum),
        .In_AndResult(and_result),
        .In_XorResult(xor_result),
        .In_SltResult(slt_result),
        .Sel(ALUControl),
        .Out(Result)
    );

endmodule