module control_Unit(opcode,funct,aluop,RegDst,Branch_eq,Branch_ne, MemReadEn, MemtoReg, MemWriteEn, RegWriteEn, ALUSrc,ZERO,JAL_signal,Jump_signal,JR_Signal);
  //Input to determine the type of instruction
  input [5:0] opcode,funct;
  //R-Type instruction
  parameter Rtype = 6'h0,ADD = 6'h20,SUB =6'h22,OR = 6'h25,NOR = 6'h27,AND= 6'h24, SLL =6'h0,SRL = 6'h02,JR = 6'h8, XOR =6'h26,SLT=6'h2a,SGT=6'h2c;
  //I-Type instruction
  parameter ADDI =6'h8 ,ORI = 6'hd,ANDI = 6'hc,LW = 6'h23, SW = 6'h2b,XORi = 6'he,SLTI=6'ha;
  //Branch Instruction
  parameter BEQ = 6'h4, BNE = 6'h5,Jump = 6'h2,JAL = 6'h3;
  //output signal for design
  output reg [3:0]aluop;
  output reg [1:0] RegDst,ALUSrc;
  output reg  Branch_eq,Branch_ne, MemReadEn, MemtoReg, MemWriteEn, RegWriteEn,JR_Signal,ZERO,JAL_signal,Jump_signal;
 
  always @(*) begin
   aluop = 4'b0000;
	RegDst = 2'b0; Branch_eq = 1'b0;Branch_ne=1'b0; MemReadEn = 1'b0; MemtoReg = 1'b0;
	MemWriteEn = 1'b0; RegWriteEn = 1'b0; ALUSrc = 2'b00;JR_Signal = 1'b0;Jump_signal=0;
	ZERO = 1'b0; JAL_signal=1'b0;
	
    case(opcode)
		Rtype: begin
			RegDst = 2'b01;
			Branch_eq = 1'b0;
			MemReadEn = 1'b0;
			MemtoReg = 1'b0;
			MemWriteEn = 1'b0;
			RegWriteEn = 1'b1;
			ALUSrc = 2'b00;

      case(funct)
			ADD:begin
				aluop = 4'b0000;
         end 
			
         SUB:begin       
				aluop = 4'b0001;
         end
			
         OR:begin             
				aluop = 4'b0011;
         end
			
         NOR:begin              
				aluop = 4'b0100;
         end
			
         AND:begin
				aluop = 4'b0010;
         end
			
         SLL:begin
				aluop = 4'b0111;
				ALUSrc = 2'b01;
         end
			
         SRL:begin
				aluop = 4'b1000;
				ALUSrc = 2'b01;
         end
			
         JR:begin                 
				JR_Signal = 1'b1;
				RegWriteEn = 1'b0;
			end
			
         XOR:begin
				aluop = 4'b0101;
         end
			
			SLT:begin
				aluop = 4'b0110;
			end
			
			SGT:begin
				aluop = 4'b1001;
				ALUSrc = 2'b00;
			end
			
			default : ;
      endcase
      end //end R-type
		
		//I-type and other Instructions
		ADDI:begin
			aluop = 4'b0000;
			RegDst = 2'b0;
			MemReadEn = 1'b0;
			MemtoReg = 1'b0;
			MemWriteEn = 1'b0;
			RegWriteEn = 1'b1;
			ALUSrc = 2'b01;
      end
      ORI:begin
			aluop = 4'b0011;
			RegDst = 2'b0;
			MemReadEn = 1'b0;
			MemtoReg = 1'b0;
			MemWriteEn = 1'b0;
			RegWriteEn = 1'b1;
			ALUSrc = 2'b01;
      end
      ANDI:begin
			aluop = 4'b0010;
			RegDst = 2'b0;
			MemReadEn = 1'b0;
			MemtoReg = 1'b0;
			MemWriteEn = 1'b0;
			RegWriteEn = 1'b1;
			ALUSrc = 2'b01;
      end
      LW:begin
			aluop = 4'b0000;
			RegDst = 2'b0;
			MemReadEn = 1'b1;
			MemtoReg = 1'b1;
			MemWriteEn = 1'b0;
			RegWriteEn = 1'b1; 		
			ALUSrc = 2'b01;
      end
      SW:begin
			aluop = 4'b0000;
			RegDst = 2'b0;
			MemReadEn = 1'b0;
			MemWriteEn = 1'b1;
			RegWriteEn = 1'b0;
			ALUSrc = 2'b01;
      end
			XORi:begin
			aluop = 4'b0101;
			RegDst = 2'b0;
			MemReadEn = 1'b0;
			MemtoReg = 1'b0;
			MemWriteEn = 1'b0;
			RegWriteEn = 1'b1;
			ALUSrc = 2'b01;
      end
      BEQ:begin
			aluop = 4'b0001;
			Branch_eq = 1'b1;
			MemReadEn = 1'b0;
			MemWriteEn = 1'b0;
			RegWriteEn = 1'b0;
			ALUSrc = 2'b00;
			ZERO =1;
      end
      BNE:begin
			aluop = 4'b0001;
			Branch_ne = 1'b1;
			MemReadEn = 1'b0;
			MemWriteEn = 1'b0;
			RegWriteEn = 1'b0;
			ALUSrc = 2'b00;
			ZERO=0;
      end
      SLTI:begin
			aluop = 4'b0110;
			RegDst = 2'b0;
			MemReadEn = 1'b0;
			MemtoReg = 1'b0;
			MemWriteEn = 1'b0;
			RegWriteEn = 1'b1;
			ALUSrc = 2'b01; 
      end
      Jump: begin
         Jump_signal = 1'b1;
      end		
		JAL:begin
			aluop = 4'b0000;
			RegDst = 2'b10;
			RegWriteEn = 1'b1;
			JAL_signal=1'b1;
			Jump_signal = 1'b1;
			ALUSrc = 2'b10;
      end
		default: begin
			aluop = 4'b0000;
			RegDst = 2'b0; Branch_eq = 1'b0; Branch_ne = 1'b0 ; MemReadEn = 1'b0; MemtoReg = 1'b0;
			MemWriteEn = 1'b0; RegWriteEn = 1'b0; ALUSrc = 2'b00;JR_Signal = 1'b0;
			JAL_signal=1'b0;
		end
    endcase
end
endmodule