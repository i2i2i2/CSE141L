/*****************************************************************************
  File Name:    ALU.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  ALU
                Input   srcA, srcB, srcC, flagin, flipin, control
                output  result, flagout, flipout, branch
                control
                  0     add or shift
                  1-2   add or shift's control
                    for shifter
                        00-11  sra, srl, srf, slf
                    for adder
                        2 - if take flag
                        1 - if add or sub
                  3-4   00 for normal, 01 - 11 for 3 different branch
                  5-6   00 for normal, 01 - 11 for different addition
                  7     if ignore flip bit
*****************************************************************************/
`include "Adder.sv"
`include "Shifter.sv"

module ALU (
  input[7:0]    srcA,           // first src
  input[7:0]    srcB,           // second src
  input[7:0]    srcC,           // third src
  input         flagin,         // overflow flag
  input         flipin,         // flip flag
  input[7:0]    control,        // control signal
  output[7:0]   result,         // computed result
  output        flagout,        // new overflow flag
  output        flipout,        // new flip flag
  output        branch          // if branch condition satisfied
);

  // wires
  wire[7:0]     srcAdd[0:3];
  wire[7:0]     addSrc;
  wire[7:0]     sum, shifted;
  wire          calcFlip, addFlag, shiftFlag;
  wire          branches[0:3];

  // add src base on control[5,6]
  assign        srcAdd[0] = srcB;
  assign        srcAdd[1] = {7'b0000000, ~srcB[7]};
  assign        srcAdd[2] = {7'b0000000, ~|(srcB[7:4] ^ srcC[7:4])};
  assign        srcAdd[3] = {7'b0000000, flagin ^ flipin};
  assign        addSrc = srcAdd[control[6:5]];

  // branch src
  assign        branches[0] = 1'b0;
  assign        branches[1] = |srcA;
  assign        branches[2] = |srcA[7:4];
  assign        branches[3] = ~|(srcA ^ 8'b00011111);
  assign        branch = branches[control[4:3]];

  // branch result
  assign        result = control[0]? shifted: sum;
  assign        flagout = control[0]? shiftFlag: addFlag;

  // find out flip
  assign        calcFlip = control[7] & (control[1] ^ flipin);

  // set flip to srcA's sign bit, if write depend on decoder
  assign        flipout = srcA[7];

  // module
  Shifter ALUshifter(srcA, control[2:1], flagin, shifted, shiftFlag);
  Adder ALUadder(srcA, addSrc, flagin, control[2], calcFlip, sum, addFlag);

endmodule
