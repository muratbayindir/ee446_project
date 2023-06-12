module CPU(
	input clk,
	input reset,

	output [31:0] PC
);

    wire PCSrcD, BranchD, RegWriteD, MemWriteD, MemToRegD;
    wire [3:0] ALUControlD;
    wire ALUSrcD, FlagWriteD;
	wire [1:0] ImmSrcD;
    wire [1:0] RegSrcD;

    wire PCSrcE, BranchE, RegWriteE, MemWriteE, MemToRegE;
    wire [3:0] ALUControlE;
    wire ALUSrcE, FlagWriteE, CondE;
	wire [1:0] ImmSrcE;

    wire PCSrcM, RegWriteM, MemWriteM, MemToRegM;

    wire PCSrcW, RegWriteW, MemToRegW;
    
	wire [1:0] Op;
	wire [5:0] Funct;
	wire [3:0] Rd;
	wire [3:0] Cond;
	
	wire n, z, c, v;

    Controller controller(
        .clk(clk), .reset(reset), .Op(Op), .Funct(Funct), .Rd(Rd), .Cond(Cond),
        .n(n), .z(z), .c(c), .v(v),
        .PCSrcD(PCSrcD), .BranchD(BranchD), .RegWriteD(RegWriteD), .MemWriteD(MemWriteD),
        .MemToRegD(MemToRegD), .ALUControlD(ALUControlD), .ALUSrcD(ALUSrcD),
        .FlagWriteD(FlagWriteD), .ImmSrcD(ImmSrcD), .RegSrcD(RegSrcD),
        .PCSrcE(PCSrcE), .BranchE(BranchE), .RegWriteE(RegWriteE), .MemWriteE(MemWriteE),
        .MemToRegE(MemToRegE), .ALUControlE(ALUControlE), .ALUSrcE(ALUSrcE),
        .FlagWriteE(FlagWriteE), .ImmSrcE(ImmSrcE), .CondE(CondE),
        .PCSrcM(PCSrcM), .RegWriteM(RegWriteM), .MemWriteM(MemWriteM), .MemToRegM(MemToRegM),
        .PCSrcW(PCSrcW), .RegWriteW(RegWriteW), .MemToRegW(MemToRegW)
    );

	Datapath datapath(
		.clk(clk),
		.reset(reset),
		.PCSrc(PCSrcW),
		.RegWrite(RegWriteW),
		.ALUSrc(ALUSrcE),
		.MemWrite(MemWriteM),
		.MemToReg(MemToRegW),
		.ImmSrc(ImmSrcD),
		.ALUControl(ALUControlE),
		.RegSrc(RegSrcD),
		.N(n),
		.Z(z),
		.C(c),
		.V(v),
		.Cond(Cond),
		.Funct(Funct),
		.Op(Op),
		.PC(PC),
		.Rd(Rd)
	);

endmodule