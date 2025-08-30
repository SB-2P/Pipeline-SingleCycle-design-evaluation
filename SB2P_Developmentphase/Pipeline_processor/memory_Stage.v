module memory_Stage(clock,alu_result,writedata2,write_data,m_signal,memory_out,ForwardE);
	input clock;
	input [31:0]alu_result,write_data, writedata2;
	input [1:0]m_signal, ForwardE;
	output [31:0]memory_out;
	wire [31:0] RAMwritedata;
	//memory
	Data_memory datamemory(.address(alu_result[9:0]),.clock(clock),.data(RAMwritedata),.rden(m_signal[1]),.wren(m_signal[0]),.q(memory_out));

	Mux4_1 #(32) WritedataMUX (.IN0(write_data), .IN1(writedata2), .IN2(memory_out), .IN3(32'b0), .S1(ForwardE[1]), .S0(ForwardE[0]) ,.OUT(RAMwritedata));


	
	
endmodule
