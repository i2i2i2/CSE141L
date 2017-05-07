/*****************************************************************************
  File Name:    ALU.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  ALU
                Input   srcA, srcB, srcC, flagin, flipin, control
                output  result, flagout, flipout, branch
                control
                  8     if add 1 or sub1
                  7     add or shift
                  6-5   add or shift's control
                    for shifter
                        00-11  sra, srl, srf, slf
                    for adder
                        2 - if take flag
                        1 - if add or sub
                  4-3   00 for normal, 01 - 11 for 3 different branch
                    01  branch if $t0 not 0
                    10  branch if upper 4 bits of $t0 not 0
                    11  branch if $acc1 not equal to 31
                  2-1   00 for normal, 01 - 11 for different addition
                    01  add 1 if srcB not negative
                    10  add 1 if upper 4 bit of srcB srcC match
                    11  add flag ^ flip
                  0     if ignore flip bit
*****************************************************************************/
`include "Adder.sv"
`include "Shifter.sv"

module ALU (
  input[7:0]    srcA,           // first src
  input[7:0]    srcB,           // second src
  input[7:0]    srcC,           // third src
  input         flagin,         // overflow flag
  input         flipin,         // flip flag
  input[8:0]    control,        // control signal
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
  assign        srcAdd[1] = {8{!srcB[7]}} & srcC;
  assign        srcAdd[2] = {7'b0000000, ~|(srcB[7:4] ^ srcC[7:4])};
  assign        srcAdd[3] = {7'b0000000, flagin ^ flipin};
  assign        addSrc = control[8]? 8'b00000001 : srcAdd[control[2:1]];

  // branch src
  assign        branches[0] = 1'b0;
  assign        branches[1] = |srcA;
  assign        branches[2] = |srcA[7:4];
  assign        branches[3] = |(srcA ^ 8'b00011111);
  assign        branch = branches[control[4:3]];

  // branch result
  assign        result = control[7]? shifted: sum;
  assign        flagout = control[7]? shiftFlag: addFlag;

  // find out flip
  assign        calcFlip = control[5] ^ ((!control[0]) & flipin);

  // set flip to srcA's sign bit, if write depend on decoder
  assign        flipout = srcA[7];

  // module
  Shifter ALUshifter(srcA, control[6:5], flagin, shifted, shiftFlag);
  Adder ALUadder(srcA, addSrc, flagin, control[6], calcFlip, sum, addFlag);

endmodule
