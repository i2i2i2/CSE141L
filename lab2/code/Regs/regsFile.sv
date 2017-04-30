/*****************************************************************************
  File Name:    RegsFile.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  RegsFile, contain 6-accumulator, 4 regular, 2 single-bit
                Input   read1, isReg1, read2, isReg2, isWrite, write, isRegW, flipin, flagin, CLK
                Output  reg1, reg2, flagOut, flipOut
*****************************************************************************/
module RegsFile
