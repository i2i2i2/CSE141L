/*****************************************************************************
  File Name:    InstrFetch.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  Combination of PC, instruction memory and lookup Table;
                Input   CLK, isBranch, Branch
                Output  Instruction bit code.
*****************************************************************************/
`include "program_counter.sv"
`include "InstrMem.sv"
`include "LookupTable.sv"

module InstrFetch (
  input			init,                       // initial set pc to 0
  input 		halt,                       // halt pc, make pc stay.
  input     	isBranch,                   // 1 bit, if need branch
  input[1:0] 	branchCtrl,                 // 2-bit, which branch to take
  input 		CLK,
  output[8:0] 	Instr                       // output 9 bit instruction code
);

// wires: program counter and branchaddress
wire[7:0] pc, branch;


// lookuptable with branchCtrl as input and pc address as output 
LookupTable(branchCtrl, branch)

// program counter takes the clk, halt, init, isbranch, branchaddress output pc)
program_counter(CLK, halt, init, isBranch, branch, pc)


// instruction memory with pc as input and instruction code as output
InstrMem InMem(pc, Instr);


endmodule

