module pipeline_processor(clock,reset,ProgramCounter);
	input clock,reset;
	output [31:0]ProgramCounter;
	
	wire [31:0] data_out1_decode,data_out2_decode,instruction,instruction_out,pc4D_in,pc4D_out,immex;
	wire IF_flush;
	wire [4:0] rt,rs,rd,rd_memory_in,rd_out_exe,rt_execute,rd_execute,rs_execute;
	wire [14:0]control_unit_signal,control_unit_signalmux;
	wire [12:0]control_unit_signalmux_out;
	
	wire [1:0]memory_signal,ForwardA1 ,ForwardB1, ForwardC1, ForwardD1, ForwardE1;
	wire [1:0] ForwardCout, ForwardDout;
	wire [31:0] data_out1_execute,data_out2_execute,immex_decode;//
	wire [31:0] aluresult,ex_writedata;
	wire [31:0] alu_result_Mem,memory_out;
	wire [31:0] WB_out;
	wire regwrite_out,memtoreg_out,memread_out,NopSel,memwrite_out;
	wire Hit;
	wire [31:0] missBranchAddress;
	wire prediction,predictionOUTF,predictionOUTD;
	
	fetch_Stage Fetch(.clock(clock),.reset(reset),.address_jr(data_out1_execute),
					.JR(control_unit_signalmux_out[12]),
					.instruction(instruction),.pc_next(ProgramCounter),.IF_flush(IF_flush),
					//HIT SIGNAL AND BRANCH SIGNAL , BRANCH ADDRESS
					.HitIN(Hit),.BranchSin(control_unit_signalmux_out[11]),.missBranchAddress(missBranchAddress),.prediction(prediction)
					
					
					);
	
	IFID IF_ID_register(.clk(clock), .rst(reset),.flush(IF_flush), 
	     .instruction_in(instruction), .PC4_in(ProgramCounter),
	     .instruction_out(instruction_out), .PC4_out(pc4D_in),
		  .predictionIn(prediction),.predictionOut(predictionOUTF));	
					
	HazardDetection hazard(   .JRSignalin(control_unit_signalmux_out[12]) , 
								    .BranchSignalin(control_unit_signalmux_out[11]), 
								   .Hit(Hit),
								     .NopSel(NopSel));
								  
	
	decode_Stage decode(.clock(clock),.reset(reset),
		.instruction(instruction_out),
		.rt(rt),.rs(rs),.rd(rd),
		.immx(immex),.reg_dist(rd_out_exe),
		.write_value(WB_out),
		
		.Data1_Out_Decode(data_out1_decode),.Data2_Out_Decode(data_out2_decode),
		.CU_signal(control_unit_signal),
		.RegWriteEn_wb(regwrite_out),
		.AluResult(aluresult),.Data_MEM(memory_out),.AluResult_Mem(alu_result_Mem),
		.ForwardA(ForwardA1),.ForwardB(ForwardB1)
		);

	MUX2_1 #(15) mux_nop(.OUT(control_unit_signalmux),.S(NopSel),.IN0(control_unit_signal),.IN1(15'h0));//Singal from control unit
	//must edit
	IDEXE IDEXE_register(
    .clk(clock), .rst(reset),                     
    .data1_in(data_out1_decode), .data2_in(data_out2_decode),
    .signextend_in(immex),
    .rs_in(rs), .rt_in(rt), .rd_in(rd),
    .control_unit_signal_in(control_unit_signalmux),.PC_next_in(pc4D_in),.predictionIn(predictionOUTF),
	 
    .control_unit_signal_out(control_unit_signalmux_out[12:0]),
    .data1_out(data_out1_execute), .data2_out(data_out2_execute),
    .signextend_out(immex_decode),
    .rs_out(rs_execute), .rt_out(rt_execute), .rd_out(rd_execute),.PC_next_out(pc4D_out),.predictionOut(predictionOUTD),
	 .ForwardCin(ForwardC1), .ForwardDin(ForwardD1), .ForwardCout(ForwardCout),.ForwardDout(ForwardDout));//move to IDEXE...
	
	
	//connected The address and readdata from memory, and the Forwarding signals 
	execute Execute_stage(.alu_result(aluresult),.write_data(ex_writedata),
				.dst_reg(rd_memory_in),.Data1(data_out1_execute),.Data2(data_out2_execute),.immex(immex_decode),
				.pc(pc4D_out),.rt(rt_execute),.rd(rd_execute),.ex_signal(control_unit_signalmux_out[5:0]),

				.zero_s(control_unit_signalmux_out[10]),
				.EXEMEM_readdata(memory_out),
				.ForwardC(ForwardCout),.ForwardD(ForwardDout),
				//prediction needs
				.PredictionIn(predictionOUTD),.Hit(Hit),.missAddress(missBranchAddress)
				);
	
	   

	ForwardingUnit Forwarding_Unit(
											 .IFID_rs(rs), .IFID_rt(rt), .IFID_JalSignal(control_unit_signal[13]), .IFID_AluSrc(control_unit_signal[14]),
											 .IDEXE_rs(rs_execute), .IDEXE_rt(rt_execute),.IDEXE_rd(rd_memory_in),.IDEXE_RegWrite(control_unit_signalmux_out[9]), .IDEXE_MemRead(control_unit_signalmux_out[6]),
											          		 
											 .EXEMEM_rd(rd_out_exe), .EXEMEM_RegWrite(regwrite_out),.EXEMEM_MemRead(memread_out),     
											 .ForwardA(ForwardA1), .ForwardB(ForwardB1), .ForwardC(ForwardC1), .ForwardD(ForwardD1), .ForwardE(ForwardE1));	   			 

	//removed Writedata in and write data out.Keep the rest of the registers because we need them to forward the data. 
	EXEMEM EM_register(.clk(clock),.rst(reset),.regwrite_in(control_unit_signalmux_out[9]),.memtoreg_in(control_unit_signalmux_out[8]),.memwrite_in(control_unit_signalmux_out[7]),
							 .memread_in(control_unit_signalmux_out[8]),.aluresult_in(aluresult),.rd_in(rd_memory_in),.regwrite_out(regwrite_out),
							 .memtoreg_out(memtoreg_out),.memwrite_out(memwrite_out),.memread_out(memread_out),.aluresult_out(alu_result_Mem),.rd_out(rd_out_exe));
							 
	assign memory_signal[0] = control_unit_signalmux_out[7];//WriteEn #These two are from the Execute stage
	assign memory_signal[1] = control_unit_signalmux_out[6];//readEn	#recall that The RAM ip inputs are registerd 
	//alu result and write data from the Execute stage sent straight to the dataMemory 
	memory_Stage memory(.clock(clock),.alu_result(aluresult),.write_data(ex_writedata),.m_signal(memory_signal),.memory_out(memory_out),
									.ForwardE(ForwardE1), .writedata2(alu_result_Mem));
	
	//MEMWB EW_register(.clk(clock),.rst(reset),.regwrite_in(regwrite_out),.memtoreg_in(memtoreg_out),.readdata_in(memory_out),.aluresult_in(alu_result_Mem),
						//.rd_in(rd_out_exe),.regwrite_out(regwrite_out_wb),.memtoreg_out(memtoreg_out_wb),.readdata_out(readdata_out_wb),.aluresult_out(aluresult_out_wb),.rd_out(rd_out_wb));                      
	
	WB_Stage Write_Back(.memory_result(memory_out),.alu_result(alu_result_Mem),.wb_signal(memtoreg_out),.wb_data(WB_out));
endmodule