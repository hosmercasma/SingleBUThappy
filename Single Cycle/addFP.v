module FADD(
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] Result
);
    wire [8:0] exponentA, exponentB, shift, shiftNegative;
    wire [7:0] exponentC, exponentResult;
    wire [23:0] fractionA, fractionB, mantissaA, mantissaB;
    wire [24:0] mantissaC;
    wire [22:0] mantissaResult;
    
    // Step 1
    assign exponentA[8] = 1'b0;
    assign exponentA[7:0] = A[30:23];
    assign exponentB[8] = 1'b0;
    assign exponentB[7:0] = B[30:23];
    
    // Step 2
    assign fractionA[23] = 1'b1;
    assign fractionA[22:0] = A[22:0];
    assign fractionB[23] = 1'b1;
    assign fractionB[22:0] = B[22:0];
    
    // Step 3
    assign shift = exponentA + ~exponentB + 1;
    assign exponentC = (shift[8]) ? exponentB[7:0]: exponentA[7:0];
    // Step 4
    assign shiftNegative = ~shift + 1;
    assign mantissaA = (shift[8]) ? fractionB: fractionA;
    assign mantissaB = (shift[8]) ? fractionA >> shiftNegative: fractionB >> shift;
    // Step 5
    assign mantissaC = mantissaA + mantissaB;    
    // Step 6
    assign exponentResult = exponentC + mantissaC[24];
    assign mantissaResult = (mantissaC[24]) ? mantissaC[23:1] : mantissaC[22:0];
    // Step 7
    assign Result = {A[31], exponentResult, mantissaResult};

endmodule