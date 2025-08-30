module IFID (clk, rst,flush,   //signals for the pipe 
	     instruction_in, PC4_in,  //data from the Fetch Stage.
		  predictionIn,
	     predictionOut,
	     instruction_out, PC4_out //data to the Decode Stage
	     
);	

input clk, rst, flush,predictionIn; 
input [31:0] instruction_in , PC4_in;
output reg [31:0] instruction_out, PC4_out;
output reg predictionOut;

	always @ (posedge clk ,posedge rst)begin 
		//flush the pipe if there is a high reset or a flush signal (assuming active high reset)
		if(rst) begin 
					instruction_out <= 32'h00000000;
					PC4_out <= 32'h00000000;
					predictionOut<= 1'b0;
		end
		else if( flush )begin 
			instruction_out <= 32'h00000000;
					PC4_out <= 32'h00000000;
					predictionOut<= 1'b0;
		end 
		else  begin 
		instruction_out<=instruction_in;
		PC4_out<=PC4_in;
		predictionOut<= predictionIn;
		end
	end
endmodule 