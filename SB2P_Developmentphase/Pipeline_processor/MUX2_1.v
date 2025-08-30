module MUX2_1 #(parameter size = 32) (OUT, S, IN0, IN1);
    input [size-1:0] IN0, IN1; // Select between branch address or jump address
    output [size-1:0] OUT; // OUT is directly assigned
    input S; // Opcode for jump from control unit (if op_jump = 1) ==> select address jump after shift left by 2

    
	
	 	 mux2 mux (
	.data0x(IN0),
	.data1x(IN1),
	.sel(S),
	.result(OUT)
	);
	 
	

endmodule