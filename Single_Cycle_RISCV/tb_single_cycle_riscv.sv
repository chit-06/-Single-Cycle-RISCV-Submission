
module tb_single_cycle_riscv;

    logic clk;
    logic reset;
    logic stall;

    logic [31:0] instruction;
    logic [31:0] mem_out;

    logic [31:0] rs2_data;
    logic [31:0] alu_out;
    logic mem_write;
    logic mem_read;
    logic [2:0] fn3;
    logic [6:0] opcode;
    logic [31:0] address;

    localparam logic [31:0] BASE_ADDR = 32'h80000000;

    logic [31:0] imem [0:63];
    logic [31:0] dmem [0:63];

    integer i;
    integer errors;

    function automatic [31:0] enc_i(
        input integer imm,
        input integer rs1,
        input integer funct3,
        input integer rd,
        input integer op
    );
        enc_i = {
            imm[11:0], rs1[4:0], funct3[2:0],
            rd[4:0], op[6:0]
        };
    endfunction

    function automatic [31:0] enc_r(
        input integer funct7,
        input integer rs2,
        input integer rs1,
        input integer funct3,
        input integer rd,
        input integer op
    );
        enc_r = {
            funct7[6:0], rs2[4:0], rs1[4:0],
            funct3[2:0], rd[4:0], op[6:0]
        };
    endfunction

    function automatic [31:0] enc_s(
        input integer imm,
        input integer rs2,
        input integer rs1,
        input integer funct3,
        input integer op
    );
        enc_s = {
            imm[11:5], rs2[4:0], rs1[4:0],
            funct3[2:0], imm[4:0], op[6:0]
        };
    endfunction

    function automatic [31:0] enc_b(
        input integer imm,
        input integer rs2,
        input integer rs1,
        input integer funct3
    );
        enc_b = {
            imm[12], imm[10:5], rs2[4:0],
            rs1[4:0], funct3[2:0],
            imm[4:1], imm[11], 7'h63
        };
    endfunction

    single_cycle_riscv DUT (
        .clk(clk),
        .reset(reset),
        .stall(stall),

        .instruction(instruction),
        .mem_out(mem_out),

        .rs2_data(rs2_data),
        .alu_out(alu_out),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .fn3(fn3),
        .opcode(opcode),
        .address(address)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    always_comb begin
        instruction = 32'h00000013;

        if (address >= BASE_ADDR &&
            address < BASE_ADDR + 256) begin

            instruction =
                imem[(address - BASE_ADDR) >> 2];

        end
    end

    always_comb begin
        mem_out = 32'b0;

        if (mem_read && alu_out[31:8] == 0)
            mem_out = dmem[alu_out[7:2]];
    end

    always_ff @(posedge clk) begin

        if (mem_write && alu_out[31:8] == 0) begin

            dmem[alu_out[7:2]] <= rs2_data;

            $display(
                "STORE: Address=%h Data=%h",
                alu_out, rs2_data
            );

        end

    end

    task automatic check_word(
        input integer index,
        input logic [31:0] expected
    );

        begin

            if (dmem[index] !== expected) begin

                $display(
                    "FAIL: dmem[%0d] Expected=%h Actual=%h",
                    index, expected, dmem[index]
                );

                errors = errors + 1;

            end
            else begin

                $display(
                    "PASS: dmem[%0d] = %h",
                    index, dmem[index]
                );

            end

        end

    endtask

    initial begin

        errors = 0;
        reset = 1;
        stall = 0;

        for (i = 0; i < 64; i = i + 1) begin
            imem[i] = 32'h00000013;
            dmem[i] = 32'b0;
        end

        imem[0] = enc_i(5, 0, 0, 1, 7'h13);

        imem[1] = enc_i(7, 0, 0, 2, 7'h13);

        imem[2] = enc_r(0, 2, 1, 0, 3, 7'h33);

        imem[3] = enc_r(32'h20, 1, 2, 0, 4, 7'h33);

        imem[4] = enc_r(0, 2, 1, 7, 5, 7'h33);

        imem[5] = enc_r(0, 2, 1, 6, 6, 7'h33);

        imem[6] = enc_s(0, 3, 0, 2, 7'h23);

        imem[7] = enc_i(0, 0, 2, 7, 7'h03);

        imem[8] = enc_b(8, 7, 3, 0);

        imem[9] = enc_i(99, 0, 0, 8, 7'h13);

        imem[10] = enc_i(11, 0, 0, 8, 7'h13);

        imem[11] = enc_b(8, 2, 1, 1);

        imem[12] = enc_i(99, 0, 0, 9, 7'h13);

        imem[13] = enc_i(13, 0, 0, 9, 7'h13);

        imem[14] = 32'h0080056f;

        imem[15] = enc_i(99, 0, 0, 11, 7'h13);

        imem[16] = enc_i(16, 0, 0, 11, 7'h13);

        imem[17] = 32'h00000617;

        imem[18] = enc_i(12, 12, 0, 12, 7'h13);

        imem[19] = enc_i(0, 12, 0, 13, 7'h67);

        imem[20] = enc_i(14, 0, 0, 14, 7'h13);

        imem[21] = enc_s(4, 4, 0, 2, 7'h23);
        imem[22] = enc_s(8, 5, 0, 2, 7'h23);
        imem[23] = enc_s(12, 6, 0, 2, 7'h23);
        imem[24] = enc_s(16, 7, 0, 2, 7'h23);
        imem[25] = enc_s(20, 8, 0, 2, 7'h23);
        imem[26] = enc_s(24, 9, 0, 2, 7'h23);
        imem[27] = enc_s(28, 10, 0, 2, 7'h23);
        imem[28] = enc_s(32, 11, 0, 2, 7'h23);
        imem[29] = enc_s(36, 13, 0, 2, 7'h23);
        imem[30] = enc_s(40, 14, 0, 2, 7'h23);

        repeat (2) @(posedge clk);
        @(negedge clk);

        reset = 0;
        repeat (45) @(posedge clk);

        #1;

        $display("\n================================");
        $display("     RISC-V TEST RESULTS");
        $display("================================\n");

        check_word(0,  32'd12);           // ADD and LW
        check_word(1,  32'd2);            // SUB
        check_word(2,  32'd5);            // AND
        check_word(3,  32'd7);            // OR
        check_word(4,  32'd12);           // LW
        check_word(5,  32'd11);           // BEQ
        check_word(6,  32'd13);           // BNE
        check_word(7,  32'h8000003c);     // JAL link
        check_word(8,  32'd16);           // JALR target
        check_word(9,  32'h80000050);     // JALR link
        check_word(10, 32'd14);           // JALR execution

        $display("\n================================");

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d errors", errors);

        $display("================================\n");

        $finish;

    end

endmodule
