////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:09:07 02/16/2012
// Design Name:   TopLevel
// Module Name:   /department/home/leporter/Desktop/basic_processor/TopLevel_tb.v
// Project Name:  basic_processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TopLevel
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TopLevel_tb;

	// Inputs
	bit start;
	bit CLK;

	// Outputs
	wire halt;
	wire [3:0] write_register;
	wire [15:0] regWriteValue;
	wire REG_WRITE;
	wire [15:0] memWriteValue;
	wire MEM_WRITE;
	wire [7:0] PC;
	wire BRANCH;
	wire [15:0] InstCounter;
	wire [9:0] Instruction;

	// Instantiate the Unit Under Test (UUT)
	TopLevel uut (
		.start           , 
		.CLK             , 
		.halt            , 
		.write_register  ,
		.regWriteValue   , 
		.REG_WRITE       , 
		.memWriteValue   , 
		.MEM_WRITE       , 
		.PC              , 
		.BRANCH          , 
		.InstCounter     ,
		.Instruction
	);

	initial begin
		// Initialize Inputs

		// Wait 100 ns for global reset to finish
		#100ns;
      start = 1; 
		#10ns;
		start = 0;
		// Add stimulus here
		#550ns $stop;
	end

  always begin
     #5ns  CLK = 1;
     #5ns  CLK = 0 ; // Toggle clock every 5 ticks
  end
      
endmodule

