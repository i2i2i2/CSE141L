//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:08:46 02/16/2012 
// Design Name: 
// Module Name:    Control 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
import definitions::*;
module Control(
    input        [3:0] OPCODE,
    output logic [1:0] ALU_OP,
    output logic [1:0] ALU_SRC_B,
    output logic       REG_WRITE,
    output logic       BRANCH,
    output logic       MEM_WRITE,
    output logic       MEM_READ,
    output logic       REG_DST,
    output logic       MEM_TO_REG,
	output logic       HALT
    );
	always_comb	begin
		
	  case(OPCODE)
	  	0 :	begin
			  REG_DST    = 1;
			  BRANCH     = 0;
			  ALU_SRC_B  = 2; 	 // 2 is 0 don't care
			  ALU_OP     = kADD; 
			  MEM_TO_REG = 0;	 // use mem read
			  MEM_READ   = 1;
			  MEM_WRITE  = 0;
			  REG_WRITE  = 1;
			  HALT       = 0;
		 end
		 1 : begin
			  REG_DST    = 0;
			  BRANCH     = 0;
			  ALU_SRC_B  = 2'b1; // 1 is SE 3 bit immediate
			  ALU_OP     = kADD; 
			  MEM_TO_REG = 1;	 // use alu result
			  MEM_READ   = 0;
			  MEM_WRITE  = 0;
			  REG_WRITE  = 1;
			  HALT = 0;
		 end
		 2 : begin
			  REG_DST    = 1; 	 // don't care
			  BRANCH     = 0;
			  ALU_SRC_B  = 2; 	 // 2 is 0, don't care
			  ALU_OP     = kADD;
			  MEM_TO_REG = 1;	 // use alu, don't care
			  MEM_READ   = 0;
			  MEM_WRITE  = 1;
			  REG_WRITE  = 0;
			  HALT       = 0;
		  end
		  3 : begin
			  REG_DST    = 1;    // don't care
			  BRANCH     = 1;
			  ALU_SRC_B  = 2; 	 // 2 is zero
			  ALU_OP     = kSUB; 
			  MEM_TO_REG = 1;	 // use alu, don't care
			  MEM_READ   = 0;
			  MEM_WRITE  = 0;
			  REG_WRITE  = 0;
			  HALT       = 0;
		  end
		  15: begin
			  REG_DST    = 0;    // don't care
			  BRANCH     = 0;
			  ALU_SRC_B  = 0; 	 // 2 is zero
			  ALU_OP     = kADD; 
			  MEM_TO_REG = 1;	 // use alu, don't care
			  MEM_READ   = 0;
			  MEM_WRITE  = 0;
			  REG_WRITE  = 0;
			  HALT       = 1;
		  end
		  default: HALT = 1;
		endcase
	end

endmodule
