module ZERO(data1,data2,out,zero_signal);
	input [31:0]data1,data2;
	output out;
	input zero_signal;


//output one if BEQ and operands are equal, One if BNE and operands are not equal	
assign out = (zero_signal)?(data1 == data2):(data1 != data2);
 
 
 
endmodule
