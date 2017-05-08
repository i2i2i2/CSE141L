/*****************************************************************************
  File Name:    LookupTable.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  lookup table stores 4 8-bit instr address for branching
                Take 2-bit control signal, output 8-bit address
*****************************************************************************/
module LookupTable(
  input[1:0] control, // 2-bit control signal
  output[7:0] pc_addr // 8-bit pc to jump to
);

// declare an 8 bit register with 4 entries 
reg[7:0] branches[0:3];

// assign the pc_addr
assign pc_addr = branches[control];


initial begin
	
	// initialize the hex reads from the hex.txt file
	$readmemh("hex.txt", branches);   

end


endmodule
