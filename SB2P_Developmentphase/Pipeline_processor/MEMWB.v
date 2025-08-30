module MEMWB(
	//input signals and values
	clk, rst,
	regwrite_in, memtoreg_in,    //signals to FU and memtoreg MUX
	readdata_in, aluresult_in,   //data from memory and ALU result
	rd_in,                       //rd value for forwarding unit
	
	//output signals & values
	regwrite_out, memtoreg_out,   
	readdata_out, aluresult_out,  
	rd_out);                      


input clk, rst;
input regwrite_in, memtoreg_in;
input [31:0] readdata_in, aluresult_in;
input [4:0] rd_in;

output reg regwrite_out, memtoreg_out;
output reg [31:0] readdata_out, aluresult_out;
output reg [4:0] rd_out;

// Register values in the pipeline on the rising clock edge or reset
always @(negedge clk or posedge rst) begin
    if (rst) begin
        // Reset output signals
        regwrite_out <= 1'b0;
        memtoreg_out <= 1'b0;
        readdata_out <= 32'b0;
        aluresult_out <= 32'b0;
        rd_out <= 5'b0;
    end else begin
   	/// Transfer the inputs to outputs on the clock edge
        regwrite_out <= regwrite_in;
        memtoreg_out <= memtoreg_in;
        readdata_out <= readdata_in;
        aluresult_out <= aluresult_in;
        rd_out <= rd_in;
    end
end

endmodule

