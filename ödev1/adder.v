module Adder #(parameter N = 32) (
    input  wire [N-1:0] A,
    input  wire [N-1:0] B,
    input  wire         Cin,
    output wire [N-1:0] Sum,
    output wire         Cout
);

    assign {Cout, Sum} = {1'b0, A} + {1'b0, B} + Cin;

endmodule