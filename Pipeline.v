module DP_IF(
	input clk, reset,
	input [31:0] PC,
	output reg [31:0] PCF
);

	initial begin
		PCF <= 32'h0;
	end

	always @(posedge clk or posedge reset) begin
		if(reset == 1'b1)
			PCF <= 32'h0;
		else
			PCF <= PC;
	end

endmodule

module DP_ID(
	input clk, reset,
	input [31:0] InstrF,
	output reg [1:0] Op,
	output reg [5:0] Funct,
	output reg [3:0] Rd,
	output reg [3:0] Cond,
	output reg [3:0] Rn,
	output reg [3:0] Rm,
	output reg [23:0] Inst23
);

	always @(posedge clk) begin
		Op <= InstrF[27:26];
		Funct <= InstrF[25:20];
		Rd <= InstrF[15:12];
		Cond <= InstrF[31:28];
		Rn <= InstrF[19:16];
		Rm <= InstrF[3:0];
		Inst23 <= InstrF[23:0];
	end

endmodule

module DP_EX(
	input clk, reset,
	input [31:0] RD1,	
	input [31:0] RD2,
	input [3:0] WA3D,
	input [31:0] ExtImm,
	output reg [31:0] SrcAE,
	output reg [31:0] WriteDataE,
	output reg [3:0] WA3E,
	output reg [31:0] ExtImmE
);

	always @(posedge clk) begin
		SrcAE <= RD1;
		WriteDataE <= RD2;
		WA3E <= WA3D;
		ExtImmE <= ExtImm;
	end

endmodule

module DP_MEM(
	input clk, reset,
	input [31:0] ALUResultE,	
	input [31:0] WriteDataE,
	input [3:0] WA3E,
	output reg [31:0] A,
	output reg [31:0] WD,
	output reg [3:0] WA3M
);

	always @(posedge clk) begin
		A <= ALUResultE;
		WD <= WriteDataE;
		WA3M <= WA3E;
	end

endmodule

module DP_WB(
	input clk, reset,
	input [31:0] RD,	
	input [31:0] ALUOutM,
	input [3:0] WA3M,
	output reg [31:0] ReadDataW,
	output reg [31:0] ALUOutW,
	output reg [3:0] WA3W
);

	always @(posedge clk) begin
		ReadDataW <= RD;
		ALUOutW <= ALUOutM;
		WA3W <= WA3M;
	end

endmodule


	