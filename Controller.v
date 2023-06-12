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
	output reg [1:0] ImmSrcD,
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
	output reg [1:0] ImmSrcE,
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
	reg updateFlagsD, updateFlagsE;
	reg flagN, flagZ, flagC, flagV;

	parameter 	AND=4'b0000,
				EXOR=4'b0001,
				SubtractionAB=4'b0010,
				SubtractionBA=4'b0011,
				Addition=4'b0100,
				Addition_Carry=4'b0101,
				SubtractionAB_Carry=4'b0110,
				SubtractionBA_Carry=4'b0111,
				ORR=4'b1100,
				Move=4'b1101,
				Bit_Clear=4'b1110,
				Move_Not=4'b1111;

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
					CMD_ADD, CMD_SUB, CMD_AND, CMD_ORR: 
					begin
						RegWriteD <= 1'b1;
						ALUControlD <= Funct[4:1];
						updateFlagsD <= 1'b1;
					end
					CMD_MOV:
					begin
						RegWriteD <= 1'b1;
						ALUControlD <= Funct[4:1];
						updateFlagsD <= 1'b0;
					end
					CMD_CMP:	
					begin
						RegWriteD <= 1'b0;
						ALUControlD <= CMD_SUB;
						updateFlagsD <= 1'b1;
					end
					default:	
					begin
						RegWriteD <= 1'b0;
						ALUControlD <= Funct[4:1];
						updateFlagsD <= 1'b0;
					end
				endcase

				MemWriteD <= 1'b0;
				MemToRegD <= 1'b0;
				ALUSrcD <= Funct[5];
				FlagWriteD <= 1'b0;
				ImmSrcD <= 2'b01;
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
				ImmSrcD <= 2'b00;
				RegSrcD[0] <= 1'b0;
				RegSrcD[1] <= 1'b1;
				updateFlagsD <= 1'b0;
				
				end

			2'b10: // Branch
				begin
				
				PCSrcD <= 1'b1;
				BranchD <= 1'b1;
				RegWriteD <= 1'b1;
				MemWriteD <= 1'b0;
				MemToRegD <= 1'b0;
				ALUSrcD <= 1'b1;
				ImmSrcD <= 2'b10;
				RegSrcD[0] <= 1'b1;
				RegSrcD[1] <= 1'b0;
				updateFlagsD <= 1'b0;

				ALUControlD <= Addition;
				
				end

			default:
				PCSrcD <= 1'b0;
		endcase
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
		updateFlagsE <= updateFlagsD;

		if(updateFlagsD == 1'b1) begin
			updateFlagsD <= 1'b0;
		end

		if(updateFlagsE == 1'b1) begin
			flagN <= n;
			flagZ <= z;
			flagC <= c;
			flagV <= v;
		end
	end

	always @(posedge clk) begin
		PCSrcW <= PCSrcM;
		RegWriteW <= RegWriteM;
		MemToRegW <= MemToRegM;
	end

	always @(posedge clk) begin		
		case (Cond)
			4'b0000: CondEx = flagZ;                  // Equal / zero
			4'b0001: CondEx = ~flagZ;                 // Not equal / non-zero
			4'b1010: CondEx = flagN;                  // Negative / less than
			4'b1011: CondEx = ~flagN;                 // Positive or zero / greater than or equal
			4'b0010: CondEx = flagC;                  // Unsigned higher or same / carry set
			4'b0011: CondEx = ~flagC;                 // Unsigned lower / carry clear
			4'b0110: CondEx = flagV;                  // Overflow
			4'b0111: CondEx = ~flagV;                 // No overflow
			4'b1000: CondEx = flagC & ~flagZ;             // Unsigned higher
			4'b1001: CondEx = ~flagC | flagZ;             // Unsigned lower or same
			4'b0100: CondEx = flagZ | (flagN ^ flagV);        // Less than or equal
			4'b0101: CondEx = (flagN ^ flagV) & ~flagZ;       // Greater than
			4'b1100: CondEx = flagN ^ flagV;              // Less than
			4'b1101: CondEx = ~(flagN ^ flagV);           // Greater than or equal
			4'b1110: CondEx = 1'b1;               // Always (AL)
			// 4'b1111 is typically not used (NV / Never execute)
			default: CondEx = 0;
		endcase
	end



endmodule