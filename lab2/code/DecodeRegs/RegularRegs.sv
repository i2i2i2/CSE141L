/*****************************************************************************
  File Name:    RegularRegs.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  4 regular
                Input   read1, read2, isWrite, writeReg, writeData, CLK
                Output  reg1, reg2
*****************************************************************************/
module RegularRegs(
  read1,                      // 2-bit read1
  read2,                      // 2-bit read2
  isWrite,                    // need write?
  writeReg,                   // 2-bit reg to write to
  writeData,                  // 8-bit data to write
  CLK,
  reg1,                       // output read1
  reg2,                       // output read2
);

// input
input[1:0]    read1;
input[1:0]    read2;
input         isWrite;
input[1:0]    writeReg;
input[7:0]    writeData;
input         CLK;

// output
output[7:0]   reg1;
output[7:0]   reg2;

// TODO

endmodule
