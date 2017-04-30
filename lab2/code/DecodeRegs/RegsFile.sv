/*****************************************************************************
  File Name:    RegsFile.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  RegsFile, contain 6-accumulator, 4 regular, 2 single-bit
                Input   read1, isReg1, read2, isReg2, isWrite, writeReg,
                        writeData, isRegW, flipin, flagin, CLK
                Output  reg1, reg2, flagOut, flipOut
*****************************************************************************/
module RegsFile(
  read1,                      // 3-bit read1
  isReg1,                     // is read1 a regular register
  read2,                      // 3-bit read1
  isReg2,                     // is read2 a regular register
  isWrite,                    // need write?
  writeReg,                   // 3-bit reg to write to
  writeData,                  // data to write
  isRegW,                     // is register write to a regular register
  flipin,                     // input flip bit
  flagin,                     // input flag bit
  CLK,
  reg1,                       // data in read1
  reg2,                       // data in read2
  flipout,                    // 1-bit flip output
  flagOut                     // 1-bit flag output
);

// input
input[2:0]    read1;
input         isReg1;
input[2:0]    read2;
input         isReg2;
input         isWrite;
input[2:0]    writeReg;
input[7:0]    writeData;
input         isRegW;
input         flipin;
input         flipout;
input         CLK;

// output
output[7:0]   reg1;
output[7:0]   reg2;
output        flipout;
output        flipout;

// TODO

endmodule
