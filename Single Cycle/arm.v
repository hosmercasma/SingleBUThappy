module arm (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	B,
	WriteData,
	ReadData,
	ALUReal
	
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWrite;
	output wire B;
	output wire [31:0] ALUReal;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [3:0] ALUFlags;
	wire RegWrite;
	wire ALUSrc;
	wire MemtoReg;
	wire PCSrc;
	wire FP;
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [3:0] ALUControl;
	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:12]),
		.ALUFlags(ALUFlags),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemWrite(MemWrite),
		.B(B),
		.FP(FP),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc)
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.ALUFlags(ALUFlags),
		.PC(PC),
		.Instr(Instr),
		.FP(FP),
		.WriteData(WriteData),
		.ReadData(ReadData),
		.ALUReal(ALUReal)
	);
endmodule