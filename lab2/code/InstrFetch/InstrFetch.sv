/*****************************************************************************
  File Name:    InstrFetch.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  Combination of PC, instruction memory and lookup Table;
                Input   CLK, isBranch, Branch
                Output  Instruction bit code.
*****************************************************************************/
`include "ProgramCounter.sv"
`include "InstrMem.sv"
`include "LookupTable.sv"

module InstrFetch (
  input         init,                       // initial set pc to 0
  input         halt,                       // halt pc, make pc stay.
  input         isBranch,                   // 1 bit, if need branch
  input         resultALU,                  // 1 bit ALU calc if branch taken
  input[1:0]    branchCtrl,                 // 2-bit, which branch to take
  input         CLK,
  output[8:0] 	Instr                       // output 9 bit instruction code
);

  // wires: program counter and branchaddress
  wire[7:0]     PC, branch;
  wire          writePC;

  // wiring
  assign        writePC = isBranch & resultALU;

  // connect modules
  LookupTable branchTable(branchCtrl, branch);
  ProgramCounter intPC(branch, halt, init, writePC, CLK, PC);
  InstrMem InMem(pc, Instr);

endmodule
