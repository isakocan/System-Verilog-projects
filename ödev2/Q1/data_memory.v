module data_memory (
    input  logic        clk,
    input  logic        MemWrite,    
    input  logic [31:0] Address,     
    input  logic [31:0] WriteData,
    output logic [31:0] ReadData     
);

    parameter MEM_WORDS = 1024;
    localparam ADDR_WIDTH = $clog2(MEM_WORDS); 
    logic [31:0] memory [MEM_WORDS-1:0];
    logic [ADDR_WIDTH-1:0] word_addr;
    assign word_addr = Address[ADDR_WIDTH+1:2];

    // Write Operation
    always_ff @(posedge clk) begin
        if (MemWrite) begin
            if (word_addr < MEM_WORDS) begin
                 memory[word_addr] <= WriteData;
            end
        end
    end

    // Read Operation
    assign ReadData = (word_addr < MEM_WORDS) ? memory[word_addr] : 32'bx;

endmodule