/*****************************************************************************
  File Name:    InstrFetch.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  Combination of PC, instruction memory and lookup Table;
                Input   CLK, isBranch, Branch
                Output  Instruction bit code.
*****************************************************************************/
module InstrFetch (
  init,                       // initial set pc to 0
  halt,                       // halt pc, make pc stay.
  isBranch,                   // 1 bit, if need branch
  branchCtrl,                 // 2-bit, which branch to take
  CLK,
  Instr                       // output 9 bit instruction code
);

// inputs
input         init;
input         halt;
input         isBranch;
input[1:0]    branchCtrl;
input         CLK;

// output
output[7:0]   Instr;

// TODO

endmodule
