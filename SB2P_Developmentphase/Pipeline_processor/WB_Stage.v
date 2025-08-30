module WB_Stage(memory_result,alu_result,wb_signal,wb_data);
	input [31:0]memory_result,alu_result;
	input wb_signal;
	output [31:0]wb_data;
	
	
	mux2 muxwb (
	.data0x(alu_result),
	.data1x(memory_result),
	.sel(wb_signal),
	.result(wb_data)
	);
endmodule
