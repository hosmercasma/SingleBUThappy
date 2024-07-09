module onlyldrb(
	clk,
	B, 
	rd,
	newrd
);
	input wire clk;
	input wire B;
	input wire [31:0] rd;
	output reg [31:0] newrd;
	
	always @(*)
		if(B)
			newrd = {24'b000000000000000000000000, rd[7:0]};
		else
			newrd = rd;	
endmodule