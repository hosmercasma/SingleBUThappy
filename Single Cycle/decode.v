module decode (
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	RegW,
	MemW,
	MemtoReg,
	ALUSrc,
	B,
	ImmSrc,
	RegSrc,
	ALUControl,
	FP
);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire B;
	output wire FP;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [3:0] ALUControl;
	reg [11:0] controls;
	wire Branch;
	wire ALUOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
						controls = 12'b000001010001;
				else
						controls = 12'b000000010001;
			2'b01:
				if (Funct[0]) begin
					if(Funct[3])
						controls = 12'b00001111010;
					else 
						controls = 12'b00001111000;
				end
				else
						controls = 12'b010011101000;
			2'b10: 		controls = 12'b001101000100;
			2'b11:		controls = 12'b100000000001;
			default: 	controls = 12'bxxxxxxxxxxxx;
		endcase
	assign {FP,RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, B, ALUOp} = controls;
	
	always @(*)
		if (ALUOp) begin
			case (Funct[4:1])
				4'b0100: ALUControl = 4'b0000;
				4'b0010: ALUControl = 4'b0001;
				4'b0000: ALUControl = 4'b0010;
				4'b1100: ALUControl = 4'b0011;
				4'b0001: ALUControl = 4'b0100;
				4'b1101: ALUControl = 4'b0111;
				default: ALUControl = 4'bxxxx;
			endcase
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ((ALUControl == 4'b0000) | (ALUControl == 4'b0001));
		end
		else begin
			ALUControl = 4'b0000;
			FlagW = 2'b00;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule