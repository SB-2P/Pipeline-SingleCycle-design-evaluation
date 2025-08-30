module programCounter (clk, rst, PCin, PCout);
	
	//inputs
	input clk, rst;
	input [9:0] PCin;
	
	//outputs 
	output reg [9:0] PCout;
	
	//Counter logic

	always@(posedge clk, negedge rst) begin
		//reset program counter
		if(~rst) begin
			PCout <= 10'b11_1111_1111;

		end
		else begin
			PCout <= PCin;
		end
	end
	
endmodule

