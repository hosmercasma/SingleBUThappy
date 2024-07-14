module FADD(
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] Result
);
    // 32-bit internal wires
    wire [8:0] exponentA32, exponentB32, shift32, shiftNegative32;
    wire [7:0] exponentC32, exponentResult32;
    wire [23:0] fractionA32, fractionB32, mantissaA32, mantissaB32;
    wire [24:0] mantissaC32;
    wire [22:0] mantissaResult32;    
    wire [31:0] Result32;
    
    // 16-bit internal wires
    wire [5:0] exponentA16, exponentB16, shift16, shiftNegative16;
    wire [4:0] exponentC16, exponentResult16;
    wire [10:0] fractionA16, fractionB16, mantissaA16, mantissaB16;
    wire [11:0] mantissaC16;
    wire [9:0] mantissaResult16;
    wire [15:0] RawResult16;
    
    // is it 16 bit?
    wire is16bit = (A[31:16] == 16'b0) && (B[31:16] == 16'b0);
    
    // Step 1 32-bit
    assign exponentA32[8] = 1'b0;
    assign exponentA32[7:0] = A[30:23];
    assign exponentB32[8] = 1'b0;
    assign exponentB32[7:0] = B[30:23];
    // Step 2 32-bit
    assign fractionA32[23] = 1'b1;
    assign fractionA32[22:0] = A[22:0];
    assign fractionB32[23] = 1'b1;
    assign fractionB32[22:0] = B[22:0];
    // Step 3 32-bit
    assign shift32 = exponentA32 + ~exponentB32 + 1;
    assign exponentC32 = (shift32[8]) ? exponentB32[7:0]: exponentA32[7:0];
    // Step 4 32-bit
    assign shiftNegative32 = ~shift32 + 1;
    assign mantissaA32 = (shift32[8]) ? fractionB32 : fractionA32;
    assign mantissaB32 = (shift32[8]) ? fractionA32 >> shiftNegative32 : fractionB32 >> shift32;
    // Step 5 32-bit
    assign mantissaC32 = mantissaA32 + mantissaB32;  
    // Step 6 32-bit
    assign exponentResult32 = exponentC32 + mantissaC32[24];
    assign mantissaResult32 = (mantissaC32[24]) ? mantissaC32[23:1] : mantissaC32[22:0];
    // Step 7 32-bit
    assign Result32 = {A[31], exponentResult32, mantissaResult32};
    
    
    
    // Step 1 16-bit
    assign exponentA16[5] = 1'b0;
    assign exponentA16[4:0] = A[14:10];
    assign exponentB16[5] = 1'b0;
    assign exponentB16[4:0] = B[14:10];        
    // Step 2 16-bit
    assign fractionA16[10] = 1'b1;
    assign fractionA16[9:0] = A[9:0];
    assign fractionB16[10] = 1'b1;
    assign fractionB16[9:0] = B[9:0];
    // Step 3 16-bit   
    assign shift16 = exponentA16 + ~exponentB16 + 1;
    assign exponentC16 = (shift16[5]) ? exponentB16[4:0]: exponentA16[4:0];
    // Step 4 16-bit
    assign shiftNegative16 = ~shift16 + 1;
    assign mantissaA16 = (shift16[5]) ? fractionB16 : fractionA16;
    assign mantissaB16 = (shift16[5]) ? fractionA16 >> shiftNegative16 : fractionB16 >> shift16;
    // Step 5 16-bit
    assign mantissaC16 = mantissaA16 + mantissaB16;
    // Step 6 16-bit
    assign exponentResult16 = exponentC16 + mantissaC16[11];
    assign mantissaResult16 = (mantissaC16[11]) ? mantissaC16[10:1] : mantissaC16[9:0];
    // Step 7 16-bit
    assign RawResult16 = {A[15], exponentResult16, mantissaResult16};
    
    //Extend the 16-bit result to 32-bits by filling the upper bits with zeros
    wire [31:0] ExtendedResult16;
    assign ExtendedResult16 = {16'b0 , RawResult16};
    
    assign Result = is16bit ? ExtendedResult16 : Result32;

endmodule