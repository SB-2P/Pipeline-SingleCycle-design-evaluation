module Control_Unit(opcode,funct,aluop,RegDst,JAL_signal,Branch, MemReadEn, MemtoReg, MemWriteEn, RegWriteEn, ALUSrc,JR_Signal,ZERO_s);
  input [5:0] opcode,funct;
  
  parameter Rtype = 6'h0,ADD = 6'h20, SUB =6'h22,OR = 6'h25,NOR = 6'h27,AND= 6'h24, SLL =6'h0,SRL = 6'h02,JR = 6'h8, XOR =6'h26,SLT=6'h2a,SGT=6'h2c;

  parameter ADDI =6'h8 ,ORI = 6'hd,ANDI = 6'hc,LW = 6'h23, SW = 6'h2b,XORi = 6'he,SLTI=6'ha;
  parameter BEQ = 6'h4, BNE = 6'h5,J = 6'h2,JAL = 3'h3;

  output reg [3:0]aluop;
  output reg [1:0] RegDst;
  output reg  Branch, MemReadEn, MemtoReg, MemWriteEn, RegWriteEn,JR_Signal,ZERO_s,JAL_signal,ALUSrc;
 
  always @(*) begin
        aluop = 4'b0000;
	RegDst = 2'b0; Branch = 1'b0; MemReadEn = 1'b0; MemtoReg = 1'b0;
	MemWriteEn = 1'b0; RegWriteEn = 1'b0; ALUSrc = 1'b0;JR_Signal = 1'b0;
	ZERO_s = 1'b0; JAL_signal=1'b0;
    case(opcode)
      Rtype: begin
	  RegDst = 2'b01;
	  Branch = 1'b0;
 	  MemReadEn = 1'b0;
	  MemtoReg = 1'b0;
	  MemWriteEn = 1'b0;
	  RegWriteEn = 1'b1;
	  ALUSrc = 1'b0;

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
			ALUSrc = 1'b1;
                end
                SRL:begin
			aluop = 4'b1000;
			ALUSrc = 1'b1;
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
			ALUSrc = 1'b0;
		end
		default : ;
          endcase
      end
		
      ADDI:begin
        aluop = 4'b0000;
	
	RegDst = 2'b0;
	Branch = 1'b0;
	MemReadEn = 1'b0;
	MemtoReg = 1'b0;
	MemWriteEn = 1'b0;
	RegWriteEn = 1'b1;
	ALUSrc = 1'b1;
      end
      ORI:begin
        aluop = 4'b0011;

	RegDst = 2'b0;
	Branch = 1'b0;
	MemReadEn = 1'b0;
	MemtoReg = 1'b0;
	MemWriteEn = 1'b0;
	RegWriteEn = 1'b1;
	ALUSrc = 1'b1;
      end
      ANDI:begin
        aluop = 4'b0010;

	RegDst = 2'b0;
	Branch = 1'b0;
	MemReadEn = 1'b0;
	MemtoReg = 1'b0;
	MemWriteEn = 1'b0;
	RegWriteEn = 1'b1;
	ALUSrc = 1'b1;
      end
      LW:begin
        aluop = 4'b0000;

	RegDst = 2'b0;
	Branch = 1'b0;
	MemReadEn = 1'b1;
	MemtoReg = 1'b1;
	MemWriteEn = 1'b0;
	RegWriteEn = 1'b1; 		
	ALUSrc = 1'b1;

      end
      SW:begin
        aluop = 4'b0000;

	RegDst = 2'b0;
	Branch = 1'b0;
	MemReadEn = 1'b0;
	MemWriteEn = 1'b1;
	RegWriteEn = 1'b0;
	ALUSrc = 1'b1;

      end
      XORi:begin
        aluop = 4'b0101;
	
	RegDst = 2'b0;
	Branch = 1'b0;
	MemReadEn = 1'b0;
	MemtoReg = 1'b0;
	MemWriteEn = 1'b0;
	RegWriteEn = 1'b1;
	ALUSrc = 1'b1;
      end
      BEQ:begin
			Branch = 1'b1;
			MemReadEn = 1'b0;
			MemWriteEn = 1'b0;
			RegWriteEn = 1'b0;
			ALUSrc = 1'b0;
			ZERO_s =1;
      end
      BNE:begin
			Branch = 1'b1;
			MemReadEn = 1'b0;
			MemWriteEn = 1'b0;
			RegWriteEn = 1'b0;
			ALUSrc = 1'b0;
			ZERO_s=0;
      end
      SLTI:begin
        aluop = 4'b0110;
	
	RegDst = 2'b0;
	Branch = 1'b0;
	MemReadEn = 1'b0;
	MemtoReg = 1'b0;
	MemWriteEn = 1'b0;
	RegWriteEn = 1'b1;
	ALUSrc = 1'b1;
      end
      J: begin
        //no aluop
	RegDst =1'b0;
      end
      JAL:begin
        aluop = 4'b0000;
	RegDst = 2'b10;
	RegWriteEn = 1'b1;
	JAL_signal=1'b1;
	ALUSrc = 1'b0;
      end
	default: begin
		aluop = 4'b0000;
	RegDst = 2'b0; Branch = 1'b0; MemReadEn = 1'b0; MemtoReg = 1'b0;
	MemWriteEn = 1'b0; RegWriteEn = 1'b0; ALUSrc = 1'b0;JR_Signal = 1'b0;
	ZERO_s = 1'b0; JAL_signal=1'b0;
	end
    endcase
end
endmodule