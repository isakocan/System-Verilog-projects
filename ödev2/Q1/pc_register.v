module pc_register (
    input  logic        clk,
    input  logic [31:0] NextPC,   
    output logic [31:0] PC        
);

    initial PC = 32'h00000000;

    always_ff @(posedge clk) begin
        PC <= NextPC;
    end
endmodule