/*****************************************************************************
  File Name:    AccumulatorRegs.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  6 accumulators
                Input   read1, read2, isWrite, writeReg, writeData, CLK
                Output  acc1, acc2
*****************************************************************************/
module AccumulatorRegs(
  read1,                    // 3-bit acc addr1
  read2,                    // 3-bit acc addr2
  isWrite,                  // do we need write
  writeReg,                 // 3-bit acc addr to write
  writeData,                // 8-bit data to write to
  CLK,
  acc1,                     // data at addr1
  acc2                      // data at addr2
);

// input
input[2:0]    read1;
input[2:0]    read2;
input         isWrite;
input[2:0]    writeReg;
input[7:0]    writeData;
input         CLK;

// output
output        acc1;
output        acc2;

// TODO

endmodule
