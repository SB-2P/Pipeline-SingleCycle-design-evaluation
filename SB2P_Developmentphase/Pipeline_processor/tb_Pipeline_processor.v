`timescale 1ns/1ps
module tb_Pipeline_processor;

	reg clk, rst;
	
	wire [31:0] PC;
	
	initial begin
		clk = 0;
		rst = 1;
		#4 rst = 0;
		#1500 $stop;
	end
	
	always #5 clk = ~clk;
		
	
	pipeline_processor uut(.clock(clk),.reset(rst),.ProgramCounter(PC));	
endmodule