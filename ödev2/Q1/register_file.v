module register_file (
    input  logic        clk,
    input  logic        RegWrite,
    input  logic [4:0]  rs1_addr, rs2_addr, rd_addr,
    input  logic [31:0] WriteData,
    output logic [31:0] ReadData1, ReadData2
);

    logic [31:0] registers [31:0];

    always_ff @(posedge clk) begin
        if (RegWrite && (rd_addr != 5'b00000)) begin 
            registers[rd_addr] <= WriteData;
        end
    end

    assign ReadData1 = (rs1_addr == 5'b00000) ? 32'b0 : registers[rs1_addr];
    assign ReadData2 = (rs2_addr == 5'b00000) ? 32'b0 : registers[rs2_addr];

endmodule