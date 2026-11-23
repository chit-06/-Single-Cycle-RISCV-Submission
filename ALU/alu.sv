
module alu #(
    parameter int DATA_WIDTH = 32
)(
    input  logic [4:0]                  alu_control,
    input  logic [DATA_WIDTH-1:0]       rs1_data,
    input  logic [DATA_WIDTH-1:0]       rs2_data,
    output logic [DATA_WIDTH-1:0]       alu_out,
    output logic                        zero
);

    always_comb begin

        alu_out = '0;
        zero    = 1'b0;

        case (alu_control)

            // ADD
            5'b00000:
                alu_out = rs1_data + rs2_data;

            // SUB
            5'b00001:
                alu_out = rs1_data - rs2_data;

            // XOR
            5'b00010:
                alu_out = rs1_data ^ rs2_data;

            // OR
            5'b00011:
                alu_out = rs1_data | rs2_data;

            // AND
            5'b00100:
                alu_out = rs1_data & rs2_data;

            // SLL - Shift Left Logical
            5'b00101:
                alu_out = rs1_data << rs2_data[4:0];

            // SRL - Shift Right Logical
            5'b00110:
                alu_out = rs1_data >> rs2_data[4:0];

            // SRA - Shift Right Arithmetic
            5'b00111:
                alu_out = $signed(rs1_data) >>> rs2_data[4:0];

            // SLT - Set Less Than (Signed)
            5'b01000:
                alu_out = ($signed(rs1_data) < $signed(rs2_data)) ? 32'd1 : 32'd0;

            // SLTU - Set Less Than (Unsigned)
            5'b01001:
                alu_out = (rs1_data < rs2_data) ? 32'd1 : 32'd0;

            // BEQ - Branch if Equal
            5'b01010:
                zero = (rs1_data == rs2_data);

            // BNE - Branch if Not Equal
            5'b01011:
                zero = (rs1_data != rs2_data);

            // BLT - Branch if Less Than (Signed)
            5'b01100:
                zero = ($signed(rs1_data) < $signed(rs2_data));

            // BGE - Branch if Greater Than or Equal (Signed)
            5'b01101:
                zero = ($signed(rs1_data) >= $signed(rs2_data));

            // BLTU - Branch if Less Than (Unsigned)
            5'b01110:
                zero = (rs1_data < rs2_data);

            // BGEU - Branch if Greater Than or Equal (Unsigned)
            5'b01111:
                zero = (rs1_data >= rs2_data);

            default: begin
                alu_out = '0;
                zero    = 1'b0;
            end

        endcase
    end

endmodule
