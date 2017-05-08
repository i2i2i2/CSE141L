module program_counter 
(
  input CLK,
  input halt,
  input init,
  input isBranch, 
  input [7:0] branchAddr,
  //input reset,
  output [7:0] pc_addr
);


always @(posedge CLK)
  //initialize the pc 
  if(init)
    pc_addr <= 0;
  else if(halt)  //halt
    pc_addr <= pc_addr;
  else if(isBranch) //branch
    pc_addr <= branchAddr;
  else //increment
    pc_addr <= pc_addr + 1;
 
endmodule
	
	

