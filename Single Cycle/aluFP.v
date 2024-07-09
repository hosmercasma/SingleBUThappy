module aluFP (
    input wire [31:0] A, B,
    input wire ALUControl,
    output wire [31:0] result
);
    wire [31:0] CFADD;
    wire [31:0] CFMUL;

    FADD FADD (
        .A(A),
        .B(B),
        .Result(CFADD)
    );

    FMUL FMUL (
	    .FPA(A),
        .FPB(B),
        .FPResult(CFMUL)
    );

    assign result = ALUControl ? CFMUL : CFADD;

endmodule