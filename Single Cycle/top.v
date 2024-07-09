module top (
	clk,
	reset,
	WriteData,
	DataAdr,
	MemWrite,
	B
);
	input wire clk;
	input wire reset;
	output wire [31:0] WriteData;
	output wire [31:0] DataAdr;
	output wire MemWrite;
	output wire B;
	wire [31:0] PC;
	wire [31:0] Instr;
	wire [31:0] ReadData;
	wire [31:0] ReadDatafinal;
	arm arm(
		.clk(clk),
		.reset(reset),
		.PC(PC),
		.Instr(Instr),
		.MemWrite(MemWrite),
		.B(B),
		.ALUReal(DataAdr),
		.WriteData(WriteData),
		.ReadData(ReadDatafinal)
	);
	imem imem(
		.a(PC),
		.rd(Instr)
	);
	dmem dmem(
		.clk(clk),
		.we(MemWrite),
		.a(DataAdr),
		.wd(WriteData),
		.rd(ReadData)
	);

	onlyldrb ldrb(
		.clk(clk),
		.B(B), 
		.rd(ReadData),
		.newrd(ReadDatafinal)
	);

endmodule