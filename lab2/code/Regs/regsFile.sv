/*****************************************************************************
  File Name:    RegsFile.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  RegsFile, contain 6-accumulator, 4 regular, 2 single-bit
                Input   read1, isReg1, read2, isReg2, isWrite, writeReg,
                        writeData, isRegW, flipin, flagin, CLK
                Output  reg1, reg2, reg3, flagOut, flipOut
*****************************************************************************/
`include "AccumulatorRegs.sv"
`include "RegularRegs.sv"
`include "SingleBitRegs.sv"

module RegsFile(
  input[2:0]    read1,        // 3-bit read1
  input         isReg1,       // is read1 a regular register
  input[2:0]    read2,        // 3-bit read1
  input         isReg2,       // is read2 a regular register
  input         isReg3,       // is reg3 from $t0, or $acc5
  input         isWrite,      // need write?
  input[2:0]    writeReg,     // 3-bit reg to write to
  input[7:0]    writeData,    // data to write
  input         isRegW,       // is register write to a regular register
  input         flipin,       // input flip bit
  input         writeFlip,    // is write flip bit
  input         flagin,       // input flag bit
  input         writeFlag,    // is write flag bit
  input         CLK,
  output[7:0]   reg1,         // data in read1
  output[7:0]   reg2,         // data in read2
  output[7:0]   reg3,         // $acc5, always outputting
  output        flipout,      // 1-bit flip output
  output        flagout       // 1-bit flag output
);

  // wires
  wire[7:0]     outAcc1, outAcc2, outAcc3;
  wire[7:0]     outReg1, outReg2, outReg3;
  wire          isWriteReg, isWriteAcc;

  // output
  assign        reg1 = isReg1? outReg1: outAcc1;
  assign        reg2 = isReg2? outReg2: outAcc2;
  assign        reg3 = isReg3? outReg3: outAcc3;
  assign        isWriteReg = isRegW & isWrite;
  assign        isWriteAcc = (!isRegW) & isWrite;

  // connect module
  AccumulatorRegs accReg(read1, read2, isWriteAcc, writeReg, writeData, CLK, outAcc1, outAcc2, outAcc3);
  RegularRegs regReg(read1[1:0], read2[1:0], isWriteReg, writeReg[1:0], writeData, CLK, outReg1, outReg2, outReg3);
  SingleBitRegs bitReg(flipin, flagin, writeFlip, writeFlag, CLK, flipout, flagout);

endmodule
