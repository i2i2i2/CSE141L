// Company: 
// Engineer:
//
// Create Date:   13:31:49 10/27/2011
// Design Name:   reg_file
// Module Name:   reg_file_tb.v
// Project Name:  lab_basics
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: reg_file
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////

module reg_file_tb;
	parameter DT = 5,
	          WT = 32;
// DUT Input Drivers
	bit          CLK;	      // bit can be only 0, 1 (no x or z)
    bit          RegWrite;   // bit self-initializes to 0, not x (handy)
	bit [ DT-1:0] srcA,
	              srcB,
	              writeReg;
	bit [ WT-1:0] writeValue;

// DUT Outputs
	wire [WT-1:0] ReadA,
                  ReadB;

// Instantiate the Unit Under Test (UUT)
	reg_file #(.W(WT),.D(DT)) uut(
	  .CLK        ,     // .CLK(CLK),
	  .RegWrite   , 
	  .srcA       , 
	  .srcB       , 
	  .writeReg   , 
	  .writeValue , 
	  .ReadA      , 
	  .ReadB      
	);

	initial begin
// Initialize Inputs done for us by "bit"

// Wait 100 ns for global reset to finish
	  #100ns;
        
// Add stimulus here
// check if writing works
	  srcA       =  4'h1;
	  writeReg   =  4'h1;
	  writeValue = 32'h6789ABCD;
	  RegWrite   =  1;
		
	  #20ns;
// verify writing to reg 0 does not work
	  writeReg   = 4'h0;
	  writeValue = 32'hFEDC2030;
		
	  #20ns;
//verify writing without RegWrite has no impact
	  RegWrite   =  0;
	  writeReg   =  4'h2;
	  writeValue = 16'hABCD;
	  srcA       =  4'h2;
	  #20ns $stop;	
	end
always begin
  #10ns CLK = 1;
  #10ns CLK = 0;
end      
endmodule

