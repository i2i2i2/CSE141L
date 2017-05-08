/*****************************************************************************
  File Name:    ProgramCounter.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  pc, increment by clock, or set by branch
                Input   CLK, isBranch, branchAddr, init, halt
                Output  PC value
*****************************************************************************/

module ProgramCounter (
  init,                     // initial signal set pc to 0
  halt,                     // ending signal halt pc
  isBranch,                 // if to take the branch
  branchAddr,               // branch address
  CLK,                      // clock signal
  pc_addr                   // output instruction address
);

// inputs
input         init;
input         halt;
input         isBranch;
input[7:0]    branchAddr;

// outputs
output[7:0]   pc_addr;

// TODO

endmodule

