//`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:47:30 02/16/2012
// Design Name:   IF
// Module Name:   /department/home/leporter/Desktop/basic_processor/IF_tb.v
// Project Name:  basic_processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: IF
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module IF_tb;

	// Inputs
	bit Branch;
	bit [7:0] Target;
	bit Init;
	bit Halt;
	bit CLK;

	// Outputs
	wire [7:0] PC;

	// Instantiate the Unit Under Test (UUT)
	IF uut (
  	  .Branch, 
	  .Target, 
	  .Init  , 
	  .Halt  , 
	  .CLK   , 
	  .PC    
	);

  initial begin
// Wait 100 ns for global reset to finish
	 #100ns;
// Add stimulus here
	 Init          = 1;
	 #20ns  Init   = 0;
	 #20ns  Target = 20;
	 #10ns  Branch = 1;
	 #20ns  Branch = 0;
	 #20ns  Halt   = 1;
  end
      
  always begin
     #5ns  CLK = 1;
     #5ns  CLK = 0; // Toggle clock every 5 ticks
  end
		
endmodule

