module FMUL(
    input wire [31:0] FPA,
    input wire [31:0] FPB,
    output wire [31:0] FPResult
);
    // 32-bit internal wires
    wire [23:0] man_a32, man_b32;
    wire [22:0] man_res32;
    wire [7:0] exp_a32, exp_b32;
    wire [8:0] exp_res32, exp_res232;
    wire sig_a32, sig_b32, sig_res32;
    wire [47:0] product32;

    // 16-bit internal wires
    wire [10:0] man_a16, man_b16;
    wire [9:0] man_res16;
    wire [4:0] exp_a16, exp_b16;
    wire [5:0] exp_res16, exp_res216;
    wire sig_a16, sig_b16, sig_res16;
    wire [21:0] product16;

    // Determine if inputs are 16-bit
    wire is16bit = (FPA[31:16] == 16'b0) && (FPB[31:16] == 16'b0);

    // 32-bit operations
    assign sig_a32 = FPA[31];
    assign sig_b32 = FPB[31];
    assign exp_a32 = FPA[30:23];
    assign exp_b32 = FPB[30:23];
    assign man_a32[23] = 1'b1;
    assign man_a32[22:0] = FPA[22:0];
    assign man_b32[23] = 1'b1;
    assign man_b32[22:0] = FPB[22:0];
    assign sig_res32 = sig_a32 ^ sig_b32;
    assign exp_res32 = exp_a32 + exp_b32 + 8'b10000001;
    assign product32 = man_a32 * man_b32;
    assign exp_res232 = exp_res32 + product32[47];
    assign man_res32 = (product32[47]) ? product32[46:24] : product32[45:23];
    wire [31:0] Result32 = {sig_res32, exp_res232[7:0], man_res32};

    // 16-bit operations
    assign sig_a16 = FPA[15];
    assign sig_b16 = FPB[15];
    assign exp_a16 = FPA[14:10];
    assign exp_b16 = FPB[14:10];
    assign man_a16[10] = 1'b1;
    assign man_a16[9:0] = FPA[9:0];
    assign man_b16[10] = 1'b1;
    assign man_b16[9:0] = FPB[9:0];
    assign sig_res16 = sig_a16 ^ sig_b16;
    assign exp_res16 = exp_a16 + exp_b16 + 6'b011111;
    assign product16 = man_a16 * man_b16;
    assign exp_res216 = exp_res16 + product16[21];
    assign man_res16 = (product16[21]) ? product16[20:10] : product16[19:9];
    wire [15:0] RawResult16 = {sig_res16, exp_res216[4:0], man_res16};

    // Extend 16-bit result to 32-bit by filling the upper bits with zeros
    wire [31:0] ExtendedResult16 = {16'b0, RawResult16};

    // Select the appropriate result based on input bit width
    assign FPResult = is16bit ? ExtendedResult16 : Result32;
endmodule