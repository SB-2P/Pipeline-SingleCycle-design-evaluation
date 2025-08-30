module PC(pc_next,pc_out,reset,clk);
	input clk,reset;
	input  [31:0]pc_next;
	output reg [31:0]pc_out;
	
	// start with FFFFFFFF to mirror the memory IP port register
	always @(posedge clk , posedge reset)begin
		if(reset)
			pc_out <= 32'hFFFFFFFF;
		
		else begin
			pc_out <= pc_next;
		end
	end
	
		
endmodule
