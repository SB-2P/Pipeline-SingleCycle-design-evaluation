module adder32bit #(parameter size =32) (OUT,IN1,IN2);
	output [size-1:0] OUT;
	input [size-1:0]IN1,IN2;
	
	assign OUT = IN1+IN2;
	
endmodule
