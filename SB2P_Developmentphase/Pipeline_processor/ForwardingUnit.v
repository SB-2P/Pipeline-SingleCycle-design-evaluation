
//Cause of double forwarding :
//to maintain high Fmax double forwarding was introduced, where we forward the data from the MemStage to the Decode and the execute stage.
//the data physically cannot be forwarded from the wb stage because it has half a cycle to meet setup time requirments, thus needing a long clock period.



module ForwardingUnit(
IFID_rs, IFID_rt, IFID_JalSignal , IFID_AluSrc,
IDEXE_rs, IDEXE_rt, IDEXE_rd, IDEXE_RegWrite, IDEXE_MemRead, 
EXEMEM_rd, EXEMEM_RegWrite , EXEMEM_MemRead, 



//outut 
ForwardA, ForwardB , ForwardC, ForwardD, ForwardE);

//We need to forward address data and readdaata from memory stage to the decode stage to solve 2nd degree arithmatic and load RAW.
//we need to forawd address data and readdata from memory stage to the execute stage to solve 1st degree arithmatic and load Raw.

input [4:0] IFID_rs, IFID_rt, IDEXE_rs, IDEXE_rt, IDEXE_rd, EXEMEM_rd;
input IFID_JalSignal, IFID_AluSrc ,IDEXE_RegWrite,IDEXE_MemRead, EXEMEM_RegWrite , EXEMEM_MemRead;
output reg [1:0] ForwardA, ForwardB,ForwardC ,ForwardD , ForwardE;


//Always block for Forward A and Forward B logic...
always @(*)begin 
//default 

ForwardA = 2'b00; 
ForwardB = 2'b00;

if ((IFID_rs == IDEXE_rd) && (IDEXE_RegWrite ==1 ) &&  (IDEXE_rd != 5'b0))begin 
ForwardA = 2'b01;
end
		else if ((IFID_rs == EXEMEM_rd) && (EXEMEM_RegWrite ==1 ) && (EXEMEM_MemRead == 0) && (EXEMEM_rd != 5'b0))begin 
		ForwardA = 2'b10;
		end
		else if ((IFID_rs == IDEXE_rd) && (EXEMEM_MemRead ==1 ) &&  (IDEXE_rd != 5'b0))begin 
		ForwardA = 2'b11;
		end 

if ((IFID_rt == IDEXE_rd) && (IDEXE_RegWrite ==1 ) &&  (IDEXE_rd != 5'b0))begin 
ForwardB = 2'b01;
end

		else if ((IFID_rt == EXEMEM_rd) && (EXEMEM_RegWrite ==1 ) && (EXEMEM_MemRead == 0) && (EXEMEM_rd != 5'b0))begin 
		ForwardB = 2'b10;
		end
		else if ((IFID_rt == EXEMEM_rd) && (EXEMEM_MemRead == 1) && (EXEMEM_rd != 5'b0))begin 
		ForwardB = 2'b11;
		end


end

//Always block for Forward C and Forward D logic...
always @(*)begin 
//default 

ForwardC = 2'b00;
ForwardD = 2'b00;
 
if (IFID_JalSignal == 1)begin 
ForwardC = 2'b01;
end 
	
if (IFID_AluSrc == 1)begin
ForwardD = 2'b01;
end
else begin
	if ((IFID_rt == IDEXE_rd) && (IDEXE_MemRead == 1) && (IDEXE_rd != 5'b0))begin 
	ForwardD = 2'b10;
	end
	end

if((IFID_rs == IDEXE_rd) && (IDEXE_MemRead == 1) && (IDEXE_rd != 5'b0))begin 
	ForwardC = 2'b10;
	end 
	
end


always @(*)begin 
//default 
ForwardE = 2'b00;

if ((IDEXE_rt == EXEMEM_rd) && (EXEMEM_RegWrite == 1 ) && (EXEMEM_MemRead == 0) && (EXEMEM_rd != 5'b0))begin //case where add in mem, sw in execute
ForwardE = 2'b01;
end

if ((IDEXE_rt == EXEMEM_rd)  && (EXEMEM_MemRead == 1) && (EXEMEM_rd != 5'b0))begin //lw in mem, sw in execute
ForwardE = 2'b10;
end
end



endmodule