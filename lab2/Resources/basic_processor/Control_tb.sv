////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:42:06 02/16/2012
// Design Name:   Control
// Module Name:   /department/home/leporter/Desktop/basic_processor/Control_tb.v
// Project Name:  basic_processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
import definitions::*;

module Control_tb;

// Inputs
  bit [3:0] OPCODE;

// Outputs
  wire [1:0] ALU_OP;
  wire [1:0] ALU_SRC_B;
  wire REG_WRITE;
  wire BRANCH;
  wire MEM_WRITE;
  wire MEM_READ;
  wire REG_DST;
  wire MEM_TO_REG;
  wire HALT;
  op_mne op_mnemonic;

	// Instantiate the Unit Under Test (UUT)
	Control uut (
		.OPCODE    , 
		.ALU_OP    , 
		.ALU_SRC_B , 
		.REG_WRITE , 
		.BRANCH    , 
		.MEM_WRITE , 
		.MEM_READ  , 
		.REG_DST   , 
		.MEM_TO_REG, 
		.HALT
	);

	initial begin
// Wait 20 ns for global reset to finish
		#20ns;
// Add stimulus here
        OPCODE = 2;
		#20ns OPCODE = 1;
		#20ns OPCODE = 3;
		#20ns;
	end
    assign op_mnemonic = op_mne'(ALU_OP);
      
endmodule

