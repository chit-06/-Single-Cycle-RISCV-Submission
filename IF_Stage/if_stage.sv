module if_stage (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic        and_out,
    input  logic [31:0] pc_signed_offset,

    output logic [31:0] address,
    output logic [31:0] pc_new
);
    logic [31:0] next_pc;
    logic [31:0] pc_reg;

    assign pc_new = pc_reg + 32'd4;

    always_comb begin
        if (and_out)
            next_pc = pc_signed_offset;
        else
            next_pc = pc_new;
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc_reg <= 32'h8000_0000;
        else if (!stall)
            pc_reg <= next_pc;
    end

    // Current PC
    assign address = pc_reg;

endmodule
