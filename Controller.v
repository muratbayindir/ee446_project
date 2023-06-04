module Controller #(
	parameter WIDTH = 32
)(
	input clk,
	input reset,

	input [1:0] Op,
	input [5:0] Funct,
	input [3:0] Rd,
	input [3:0] Cond,

	/* ALU Flags */
	input n, z, c, v,

	/* Decode */
	output reg PCSrcD,
	output reg BranchD,
	output reg RegWriteD,
	output reg MemWriteD,
	output reg MemToRegD,
	output reg [3:0] ALUControlD,
	output reg ALUSrcD,
	output reg FlagWriteD,
	output reg ImmSrcD,
	output reg [1:0] RegSrcD,

	/* Execute */
	output reg PCSrcE,
	output reg BranchE,
	output reg RegWriteE,
	output reg MemWriteE,
	output reg MemToRegE,
	output reg [3:0] ALUControlE,
	output reg ALUSrcE,
	output reg FlagWriteE,
	output reg ImmSrcE,
	output reg CondE,

	/* Memory */
	output reg PCSrcM,
	output reg RegWriteM,
	output reg MemWriteM,
	output reg MemToRegM,

	/* Write Back */
	output reg PCSrcW,
	output reg RegWriteW,
	output reg MemToRegW
);
	reg CondEx;

	parameter CMD_ADD = 4'b0100,
			  CMD_SUB = 4'b0010,
			  CMD_AND = 4'b0000,
			  CMD_ORR = 4'b1100,
			  CMD_MOV = 4'b1101,
			  CMD_CMP = 4'b1010;

	initial begin
	end

	always @(Op or Funct or Rd) begin
		case(Op)
			2'b00: // Data Processing
				begin
				
				PCSrcD <= 1'b0;
				BranchD <= 1'b0;

				case(Funct[4:1])
					CMD_ADD, CMD_SUB, CMD_AND, CMD_ORR, CMD_MOV:	RegWriteD <= 1'b1;
					default:	RegWriteD <= 1'b0;
				endcase

				MemWriteD <= 1'b0;
				MemToRegD <= 1'b0;
				ALUSrcD <= Funct[5];
				FlagWriteD <= 1'b0;
				ImmSrcD <= 1'b0;
				RegSrcD[0] <= 1'b0;
				RegSrcD[1] <= 1'b0;
				
				end

			2'b01: // Memory
				begin
				
				PCSrcD <= 1'b0;
				BranchD <= 1'b0;
				RegWriteD <= Funct[0]; // LDR
				MemWriteD <= ~Funct[0]; // STR
				MemToRegD <= Funct[0]; // LDR
				ALUSrcD <= ~Funct[5];
				ImmSrcD <= 1'b0;
				RegSrcD[0] <= 1'b0;
				RegSrcD[1] <= 1'b1;
				
				end

			2'b10: // Branch
				begin
				
				PCSrcD <= 1'b1;
				BranchD <= 1'b1;
				RegWriteD <= 1'b1;
				MemWriteD <= 1'b0;
				MemToRegD <= 1'b0;
				ALUSrcD <= 1'b1;
				ImmSrcD <= 1'b1;
				RegSrcD[0] <= 1'b1;
				RegSrcD[1] <= 1'b0;
				
				end

			default:
				PCSrcD <= 1'b0;
		endcase

		ALUControlD <= Funct[4:1];
	end

	always @(posedge clk) begin
		PCSrcE <= PCSrcD;
		BranchE <= BranchD;
		RegWriteE <= RegWriteD;
		MemWriteE <= MemWriteD;
		MemToRegE <= MemToRegD;
		ALUControlE <= ALUControlD;
		ALUSrcE <= ALUSrcD;
		FlagWriteE <= FlagWriteD;
		ImmSrcE <= ImmSrcD;
	end

	always @(posedge clk) begin
		PCSrcM <= PCSrcE && BranchE && CondEx;
		RegWriteM <= RegWriteE && CondEx;
		MemWriteM <= MemWriteE && CondEx;
		MemToRegM <= MemToRegE;
	end

	always @(posedge clk) begin
		PCSrcW <= PCSrcM;
		RegWriteW <= RegWriteM;
		MemToRegW <= MemToRegM;
	end

	always @(posedge clk) begin
		case (Cond)
			4'b0000: CondEx <= z;                  // Equal / zero
			4'b0001: CondEx <= ~z;                 // Not equal / non-zero
			4'b1010: CondEx <= n;                  // Negative / less than
			4'b1011: CondEx <= ~n;                 // Positive or zero / greater than or equal
			4'b0010: CondEx <= c;                  // Unsigned higher or same / carry set
			4'b0011: CondEx <= ~c;                 // Unsigned lower / carry clear
			4'b0110: CondEx <= v;                  // Overflow
			4'b0111: CondEx <= ~v;                 // No overflow
			4'b1000: CondEx <= c & ~z;             // Unsigned higher
			4'b1001: CondEx <= ~c | z;             // Unsigned lower or same
			4'b0100: CondEx <= z | (n ^ v);        // Less than or equal
			4'b0101: CondEx <= (n ^ v) & ~z;       // Greater than
			4'b1100: CondEx <= n ^ v;              // Less than
			4'b1101: CondEx <= ~(n ^ v);           // Greater than or equal
			4'b1110: CondEx <= 1'b1;               // Always (AL)
			// 4'b1111 is typically not used (NV / Never execute)
			default: CondEx <= 0;
		endcase
	end



endmodule