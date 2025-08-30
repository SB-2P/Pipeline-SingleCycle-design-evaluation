module IDEXE (
    //input signals & values
    clk, rst,                     
    data1_in, data2_in,       // Register values (32 bits)
    signextend_in,           // Sign-extended immediate value (32 bits)
    rs_in, rt_in, rd_in,      // Register addresses (5 bits each) note: in the datapath rt is passed twice, no need to actually do tthat.
    control_unit_signal_in,PC_next_in,
	 predictionIn,
	 //output signals &values
    control_unit_signal_out,
    data1_out, data2_out,     // Register values (32 bits)
    signextend_out,          // Sign-extended immediate value (32 bits)
    rs_out, rt_out, rd_out,PC_next_out,    // Register addresses (5 bits each)
	 predictionOut,
	 ForwardCin, ForwardDin, ForwardCout, ForwardDout
);
input clk, rst,predictionIn; //1-bit signals 
input [12:0] control_unit_signal_in;
input [31:0] data1_in, data2_in, signextend_in ,PC_next_in;
input [4:0] rs_in, rt_in, rd_in;
input [1:0] ForwardCin, ForwardDin;

output reg[31:0] data1_out, data2_out, signextend_out,PC_next_out;
output reg[4:0] rs_out, rt_out, rd_out;
output reg[12:0] control_unit_signal_out;
output reg [1:0] ForwardCout, ForwardDout;
output reg predictionOut;
// Sequential logic block
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset outputs to default values
		  control_unit_signal_out <= 12'b0;
        data1_out <= 32'b0;
        data2_out <= 32'b0;
        signextend_out <= 32'b0;
        rs_out <= 5'b0;
        rt_out <= 5'b0;
        rd_out <= 5'b0;
		  PC_next_out <= 32'b0;
		  ForwardCout<= 2'b0;
		  ForwardDout <=2'b0;
		  predictionOut<=1'b0;
    end 
    else begin
        // Transfer the inputs to outputs on the clock edge
        control_unit_signal_out <= control_unit_signal_in;
        data1_out <= data1_in;
        data2_out <= data2_in;
        signextend_out <= signextend_in;
        rs_out <= rs_in;
        rt_out <= rt_in;
        rd_out <= rd_in;
		  PC_next_out <= PC_next_in;
		  ForwardCout<= ForwardCin;
		  ForwardDout <=ForwardDin;
		  predictionOut<=predictionIn;
	 end
	 
end

endmodule
