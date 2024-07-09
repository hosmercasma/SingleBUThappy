module FMUL(
    input wire [31:0] FPA,
    input wire [31:0] FPB,
    output wire [31:0] FPResult
);
    wire [23:0] man_a, man_b;
    wire [22:0] man_res;
    wire [7:0] exp_a, exp_b;
    wire [8:0] exp_res, exp_res2;
    wire sig_a, sig_b, sig_res;
    wire [47:0] product;

    assign sig_a = FPA[31];
    assign sig_b = FPB[31];

    assign exp_a = FPA[30:23];
    assign exp_b = FPB[30:23];

    assign man_a[23] = 1'b1;
    assign man_a[22:0] = FPA[22:0];
    assign man_b[23] = 1'b1;
    assign man_b[22:0] = FPB[22:0];

    assign sig_res = sig_a ^ sig_b;
    assign exp_res = exp_a + exp_b + 8'b10000001;
    assign product = man_a * man_b;

    assign exp_res2 = exp_res + product[47];
    assign man_res = (product[47]) ? product[46:24] : product[45:23];

    assign FPResult = { sig_res, exp_res2[7:0], man_res};
endmodule
