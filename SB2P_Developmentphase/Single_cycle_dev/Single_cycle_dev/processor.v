module processor(clk, rst, PC);

	//inputs
	input clk, rst;
	
	//outputs
	output [9:0] PC;
	
	wire [31:0] instruction, writeData, readData1, readData2, extImm, ALUin2,ALUin1,ALUResult, memoryReadData;
	wire [15:0] imm;
	wire [5:0] opCode, funct;
	wire [4:0] rs, rt, rd, writeRegister;
	wire [3:0] ALUOp;
	wire  MemReadEn, MemtoReg, MemWriteEn, RegWriteEn, zero, PCsrc,JR_Signal,Jump_signal,JAL_signal,Branch_eq,Branch_ne;
	wire S0,S1,Andout1,Andout2;
	wire [9:0] nextPC, PCPlus1, adderResult,jumpAddress;
	wire [1:0] ALUSrc,RegDst;

	assign opCode = instruction[31:26];
	assign rd = instruction [15:11]; 
	assign rs = instruction[25:21]; 
	assign rt = instruction[20:16]; 
	assign imm = instruction[15:0];
	assign funct = instruction[5:0];
	assign jumpAddress = instruction[9:0];
	
	programCounter pc(.clk(clk), .rst(rst), .PCin(nextPC), .PCout(PC));  
	
	adder PCAdder(.in1(PC), .in2(10'b1), .out(PCPlus1));
	
	instructionMemory IM(.address(nextPC), .clock(clk), .q(instruction));
	
	control_Unit CU(.opcode(opCode), .funct(funct), 
				      .RegDst(RegDst), .Branch_eq(Branch_eq),.Branch_ne(Branch_ne), .MemReadEn(MemReadEn), .MemtoReg(MemtoReg),
				      .aluop(ALUOp), .MemWriteEn(MemWriteEn), .RegWriteEn(RegWriteEn), .ALUSrc(ALUSrc),
					  .JAL_signal(JAL_signal),.Jump_signal(Jump_signal),.JR_Signal(JR_Signal));
					  
	//Register Destination Mux
	mux4_1 #(5) RFMux(.IN0(rt),.IN1(rd),.IN2(5'b11111),.IN3(5'b0),.S0(RegDst[0]),.S1(RegDst[1]),.OUT(writeRegister));
	
	registerfile RF(.clk(clk), .rst(rst), .we(RegWriteEn), 
					    .readRegister1(rs), .readRegister2(rt), .writeRegister(writeRegister),
					    .writeData(writeData), .readData1(readData1), .readData2(readData2));
						 
	SignExtender SignExtend(.in(imm), .out(extImm));
	
	//ALU-Inputs Mux
	mux4_1 #(32) ALUMux(.IN0(readData2),.IN1(extImm),.IN2(32'b0),.IN3(32'b0),.S0(ALUSrc[0]),.S1(ALUSrc[1]),.OUT(ALUin2)); 
	
	mux2x1 #(32) JAL(.in1(readData1), .in2({22'b0,PCPlus1}), .s(JAL_signal), .out(ALUin1));  
	
	ALU alu(.operand1(ALUin1), .operand2(ALUin2), .opSel(ALUOp), .result(ALUResult), .zero(zero));
	
	//equation for Branch 
	ANDGate branchAnd1(.in1(zero), .in2(Branch_eq), .out(Andout1));
	ANDGate branchAnd2(.in1(~zero), .in2(Branch_ne), .out(Andout2));
	
	assign PCsrc = Andout1 | Andout2;
	
	//equation to determine selector For Mux Next Pc
	assign S0= PCsrc | ((~JR_Signal)&Jump_signal);
	assign S1= JR_Signal | PCsrc;
	
	//Mux For Next Pc
	mux4_1 #(10) nextPc(.IN0(PCPlus1),.IN1(jumpAddress),.IN2(readData1),.IN3(adderResult),.S0(S0),.S1(S1),.OUT(nextPC));
	
	//calculate Branch address
	adder branchAdder(.in1(PCPlus1), .in2(extImm[9:0]), .out(adderResult));   
	
	dataMemory DM(.address(ALUResult[9:0]), .clock(~clk), .data(readData2), .rden(MemReadEn), .wren(MemWriteEn), .q(memoryReadData));
	
	mux2x1 #(32) WBMux(.in1(ALUResult), .in2(memoryReadData), .s(MemtoReg), .out(writeData));

	
	
endmodule
