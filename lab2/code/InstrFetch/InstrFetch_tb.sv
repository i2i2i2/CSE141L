/*****************************************************************************
  File Name:    InstrFetch.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  Combination of PC, instruction memory and lookup Table;
                Input   CLK, isBranch, Branch
                Output  Instruction bit code.
*****************************************************************************/
`timescale 1ns / 100ps
`include "InstrFetch.sv"

module InstrFetch_tb;

  reg           init, halt, isBranch, resultALU, CLK;
  reg[1:0]      branchCtrl;
  wire[8:0]     instr;

  InstrFetch IFTest(init, halt, isBranch, resultALU, branchCtrl, CLK, instr);

  always begin
    #5 CLK = 1;
    #5 CLK = 0;
  end

  initial begin
    $dumpfile("InstrFetchTest.vcd");
    $dumpvars(0, InstrFetch_tb);

    init = 1'b1;

    #10;        // initialize
    halt = 1'b0; isBranch = 1'b0; init = 1'b0;
    $strobe("Instr = %b (000000000)", instr);

    #5;        // let clock run
    $strobe("Instr = %b (000000001)", instr);

    #10;        // let clock run
    $strobe("Instr = %b (000000010)", instr);

    #10;        // let clock run
    $strobe("Instr = %b (000000011)", instr);

    #10;        // let clock run
    $strobe("Instr = %b (000000100)", instr);

    #10;        // try failed branch
    isBranch = 1'b1; resultALU = 1'b0;
    $strobe("Instr = %b (000000101)", instr);

    #10;        // try successfull branch
    resultALU = 1'b1; branchCtrl = 2'b01;
    $strobe("Instr = %b (000000011)", instr);

    #10;        // test halt
    halt = 1'b1;
    $strobe("Instr = %b (000000011)", instr);

    #10;
    $strobe("Instr = %b (000000011)", instr);

    #10;
    $finish;
  end

endmodule
