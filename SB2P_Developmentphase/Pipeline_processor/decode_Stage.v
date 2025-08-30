module decode_Stage(clock,reset,
		instruction,
		rt,rs,rd,
		immx,reg_dist,
		write_value,
		//
		Data1_Out_Decode,Data2_Out_Decode,
		CU_signal,
		RegWriteEn_wb,
		AluResult,AluResult_Mem,Data_MEM,
		ForwardA,ForwardB
);

	input [31:0]instruction,write_value,AluResult,AluResult_Mem,Data_MEM;
	input [4:0]reg_dist;
	input clock,reset,RegWriteEn_wb;
	input [1:0]ForwardA,ForwardB;
	
	
	output [31:0]immx;
	output [4:0]rt,rs,rd;
	output [31:0]Data1_Out_Decode,Data2_Out_Decode;//
	
	
	wire [31:0] data1,data2;
	wire  MemReadEn, MemtoReg, MemWriteEn, RegWriteEn,JAL_signal,ZERO_s,Branch,ALUSrc , JR_Signal;
	wire [15:0]imm;
	wire [3:0] aluop;
	wire [1:0]RegDst;
	wire [5:0]opcode,funct;
	assign opcode = instruction[31:26];
	assign rs = instruction[25:21];
	assign rt = instruction[20:16];
	assign rd = instruction[15:11];
	assign imm = instruction[15:0];
	assign funct = instruction[5:0];
	//wire[31:0] imms;

	output [14:0] CU_signal;
	
	assign CU_signal[1:0]=RegDst;
	assign CU_signal[5:2]=aluop;
	
	assign CU_signal[6]=MemReadEn;
	assign CU_signal[7]=MemWriteEn;
	assign CU_signal[8]=MemtoReg;
	assign CU_signal[9]=RegWriteEn;
	assign CU_signal[10]=ZERO_s;
	assign CU_signal[11]=Branch;
	assign CU_signal[12]=JR_Signal;//
	
	assign CU_signal[13]=JAL_signal;//
	assign CU_signal[14]=ALUSrc;//
	
	Sign_Extend S_E(.in(imm),.out(immx));

	RegisterFile registerfile(.Data1(data1) ,.Data2(data2) , .RS(rs) , .RT(rt) , .write_reg(reg_dist) , 
			.WriteData(write_value) , .RegW(RegWriteEn_wb) , .clk(clock) ,.reset(reset) );
			
	Mux4_1 #(32) MUX_Forwarding1(.IN0(data1),.IN1(AluResult),.IN2(AluResult_Mem),.IN3(Data_MEM),.S0(ForwardA[0]),.S1(ForwardA[1]),.OUT(Data1_Out_Decode));
	
	Mux4_1 #(32) MUX_Forwarding2(.IN0(data2),.IN1(AluResult),.IN2(AluResult_Mem),.IN3(Data_MEM),.S0(ForwardB[0]),.S1(ForwardB[1]),.OUT(Data2_Out_Decode));

	Control_Unit controlunit(.opcode(opcode),.funct(funct),.aluop(aluop),.RegDst(RegDst),.JAL_signal(JAL_signal),
			 .Branch(Branch),.MemReadEn(MemReadEn), .MemtoReg(MemtoReg),.MemWriteEn(MemWriteEn),
			 .RegWriteEn(RegWriteEn), .ALUSrc(ALUSrc),.JR_Signal(JR_Signal),.ZERO_s(ZERO_s));
  
endmodule