/*****************************************************************************
  File Name:    SingleBitRegs.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  2 single-bit
                Input   flipin, flagin, CLK
                Output  flipout, flagout
*****************************************************************************/
module SingleBitRegs (
  flipin,                     // flip to update
  flagin,                     // flag to update
  CLK,
  flipout,                    // output flip
  flagout                     // output flag
);

// input
input         flipin;
input         flagin;
input         CLK;

// output
output        flipout;
output        flagout;

// TODO

endmodule
