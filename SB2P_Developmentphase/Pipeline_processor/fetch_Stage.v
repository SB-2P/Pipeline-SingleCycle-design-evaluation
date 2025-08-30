module fetch_Stage(clock,reset,address_jr,instruction,pc_next,IF_flush,

//prediction requirements
JR,HitIN,BranchSin,missBranchAddress,prediction

);
	input clock,reset;
	input [31:0]address_jr,missBranchAddress;
	input JR,BranchSin , HitIN;//Signal of mux selector
	output [31:0]instruction,pc_next;
	output IF_flush, prediction;
	wire [31:0]pc_out,JumpToAddress,pc2out;
	wire S0,S1;
	reg [9:0]counter;
	wire [1:0]sel = {S1, S0};
	PC pc(.pc_next(pc_next),.pc_out(pc_out),.reset(reset),.clk(clock));

	Instruction_memory instruction_mem(.address(pc_next[9:0]),.clock(clock),.q(instruction));
	
	adder32bit adder_32bit(.OUT(pc2out),.IN1(pc_out),.IN2(32'h1));

	mux4 mux4_1(.data0x(pc2out),.data1x(JumpToAddress),.data2x(address_jr),.data3x(missBranchAddress),.sel(sel),.result(pc_next));

	
	//jump unit
	Jump_unit jumpunit(.instruction(instruction),.PC(pc_out),.PC1(pc2out),.JRSignal(JR),.BranchSignal(BranchSin),.Hit(HitIN),.IF_flush(IF_flush),.S0(S0),.S1(S1),.JumpToAddress(JumpToAddress),.prediction(prediction));
	
	always@(posedge clock or posedge reset)begin
	if (reset)begin 
	counter <=0;
	end 
	else begin 
	counter <= counter + 10'b1 ;  

	end 
	end
endmodule