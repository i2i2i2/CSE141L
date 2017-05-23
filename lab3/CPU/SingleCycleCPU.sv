/*****************************************************************************
  File Name:    SingleCycleCPU.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  put every module together
*****************************************************************************/
`timescale 1ns / 100ps
`include "ALU.sv"
`include "DataMem.sv"
`include "InstrFetch.sv"
`include "InstrDecoder.sv"
`include "RegsFile.sv"

module SingleCycleCPU;

  wire[8:0]     instr, control;
  wire[7:0]     regData, addr, dataIn, dataOut, result, srcA, srcB, srcC;
  wire[2:0]     read1, read2, writeReg, regSrc;
  wire[1:0]     branchCtrl;
  wire          memOp, writeBranch, isReg1, isReg2, isReg3, isWrite, writeFlip,
                isRegW, writeFlag, flag0, flag1, flip0, flip1, branchResult, halt,
                onebit, writeBit;

  reg           init, CLK;

  InstrFetch IF(init, halt, writeBranch, branchResult, branchCtrl, CLK, instr);
  InstrDecode ID(instr, writeBranch, branchCtrl, halt, control, read1, isReg1,
      read2, isReg2, isReg3, isWrite, writeReg, isRegW, regData, writeFlip,
      writeFlag, writeBit, memOp, regSrc);
  RegsFile RF(read1, isReg1, read2, isReg2, isReg3, isWrite, writeReg,
      result, regData, dataOut, srcA, regSrc, isRegW, flip0, writeFlip,
      flag0, writeFlag, flag0, writeBit, CLK, srcA, srcB, srcC, flip1, flag1, onebit);
  ALU ALU0(srcA, srcB, srcC, flag1, flip1, onebit, control, result, flag0, flip0, branchResult);
  DataMem M(srcA, srcB, memOp, CLK, dataOut);

  // initial
  initial begin
    CLK = 1'b1;
    init = 1'b1;
    #10 init = 1'b0;
  end

  // Stop after 1800 ticks
  initial begin
    #18000 $finish;
  end

  initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, SingleCycleCPU);
  end

  // CLK
  always begin
    #5 CLK = !CLK;
  end

endmodule
