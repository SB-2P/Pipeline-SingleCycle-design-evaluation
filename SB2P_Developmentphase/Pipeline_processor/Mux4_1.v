module Mux4_1 #(parameter size = 32) (IN0, IN1, IN2, IN3, S0, S1, OUT);
    input [size-1:0] IN0, IN1, IN2, IN3;
    output [size-1:0] OUT; // OUT is directly assigned
    input S0, S1;

    wire [1:0] S;

    //Concatenate the select lines to create a 2-bit selector
    assign S = {S1, S0};

	mux4 u_my_mux (
    .data0x (IN0),  // Input 0
    .data1x (IN1),  // Input 1
	 .data2x (IN2),  // Input 1
	 .data3x (IN3),  // Input 1
    .sel   (S),    // Selection line
    .result (OUT)   // Output
);
					  
endmodule