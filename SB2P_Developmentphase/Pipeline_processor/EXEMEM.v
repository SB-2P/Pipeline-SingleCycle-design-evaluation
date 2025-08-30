module EXEMEM(
	//input signa;s & values
	clk , rst , 	     	
	regwrite_in,memtoreg_in,   //WB signal
	memwrite_in, memread_in,   //execute signal
	aluresult_in,//Execute sstage data
	rd_in,			   // rd value for the forwarding unit
	//output singlas and &values
	regwrite_out,memtoreg_out,	   //same order as the input
	memwrite_out, memread_out,
	aluresult_out,
	rd_out);

input clk , rst;
input memtoreg_in, regwrite_in, memwrite_in, memread_in;
input[31:0]aluresult_in;
input [4:0]rd_in;

output reg memtoreg_out, regwrite_out, memwrite_out, memread_out;
output reg [31:0] aluresult_out ;
output reg [4:0]rd_out; 

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset outputs to default values
	memtoreg_out<=1'b0;
        regwrite_out <= 1'b0;
        memwrite_out <= 1'b0;
        memread_out <= 1'b0;
        aluresult_out <= 32'b0;
       
        rd_out <= 5'b0;
    end
    else begin
        // Transfer the inputs to outputs on the clock edge
	memtoreg_out<=memtoreg_in;
        regwrite_out <= regwrite_in;
        memwrite_out <= memwrite_in;
        memread_out <= memread_in;
        aluresult_out <= aluresult_in;
       
        rd_out <= rd_in;
    end
end
endmodule