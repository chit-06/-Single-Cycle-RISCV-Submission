
module register_file(
    input  logic [4:0]  rs1_sel,
    input  logic [4:0]  rs2_sel,
    input  logic        reg_write,
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] wb_data,
    input  logic [4:0]  rd_sel,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);

    logic [31:0] register [0:31];

    integer i;

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                register[i] <= 32'b0;
            end
        end

        else if (reg_write && rd_sel != 5'b00000) begin
            register[rd_sel] <= wb_data;
        end

    end

    always_comb begin

        if (rs1_sel == 5'b00000)
            rs1_data = 32'b0;
        else
            rs1_data = register[rs1_sel];

        if (rs2_sel == 5'b00000)
            rs2_data = 32'b0;
        else
            rs2_data = register[rs2_sel];

    end

endmodule
