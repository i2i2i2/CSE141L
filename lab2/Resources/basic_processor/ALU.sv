//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:04:22 10/27/2011 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
  input [ 1:0] OP,
  input [15:0] INPUTA,
  input [15:0] INPUTB,
  output logic [15:0] OUT,
  output logic ZERO,
  output wire EQUAL
    );
	 
  assign EQUAL = (INPUTA == INPUTB) ? 1 : 0;
  op_mne op_mnemonic;
	
  always_comb begin
	
	case(OP)
	  kADD : OUT = INPUTA+INPUTB;
	  kSUB : OUT = INPUTA-INPUTB;
	  kAND : OUT = INPUTA&INPUTB;
	  kXOR : OUT = INPUTA^INPUTB;
	  default: OUT = 0;
	endcase
	 
	case(OUT)
	  16'b0 :   ZERO = 1'b1;
	  default : ZERO = 1'b0;
	endcase
	//$display("ALU Out %d \n",OUT);
    op_mnemonic = op_mne'(OP);

  end

endmodule
