module execute(alu_result,write_data,dst_reg,Data1,Data2,immex,pc,rt,rd,ex_signal,zero_s,
EXEMEM_readdata,//forwarded data
ForwardC, ForwardD//forwarding Signals
,PredictionIn,Hit,missAddress
);
	output [31:0] alu_result,write_data,missAddress;
	output [4:0] dst_reg;
	output Hit;
	input [31:0]Data1,Data2,immex,pc;
	input[4:0] rt,rd;
	input [5:0] ex_signal;
	input zero_s, PredictionIn;
	input [31:0]  EXEMEM_readdata;
	input [1:0] ForwardC, ForwardD;
	wire zero_equ;
	wire [31:0]address_b,pc_After_branch;
	wire [31:0]wire_alu_input1,wire_alu_input2;
	wire Hit;
	
	mux3 muxJAL(.data0x(Data1),.data1x(pc),.data2x(EXEMEM_readdata),.sel(ForwardC),.result(wire_alu_input1));
	
	mux3 muxAluSrc(.data0x(Data2),.data1x(immex),.data2x(EXEMEM_readdata),.sel(ForwardD),.result(wire_alu_input2));
	
	

	ALU aludesign(.operand1(wire_alu_input1),.operand2(wire_alu_input2),.opSel(ex_signal[5:2]),.result(alu_result));
	
	ZERO zero(.data1(Data1),.data2(Data2),.out(zero_equ),.zero_signal(zero_s));
	
	adder32bit #32 adder(.OUT(address_b),.IN1(pc),.IN2(immex));
	
	Mux4_1 #(5) muxdest(.IN0(rt),.IN1(rd),.IN2(5'b11111),.IN3(5'b00000),.S0(ex_signal[0]),.S1(ex_signal[1]),.OUT(dst_reg));
	
	assign write_data = Data2;
	assign pc_After_branch = pc - immex;
	//mux for Branch address, we need PC1 in case of backward miss prediction (P==1), AND target address in case of forward miss prediction (P==0)..
	mux2 missTargetAddress(.data0x(address_b),.data1x(pc_After_branch),.sel(PredictionIn),.result(missAddress));
	
	//logic for HIT signal
	assign Hit = (PredictionIn & zero_equ) | (~PredictionIn & ~zero_equ);

endmodule