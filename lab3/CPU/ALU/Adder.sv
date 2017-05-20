/*****************************************************************************
  File Name:    Adder.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  adder, check if flip is set, turn to subtracter
                Input   a, b, ci, flip
                Output  sum, co
*****************************************************************************/
module Adder(
  input[7:0]    add1,       // input 1
  input[7:0]    add2,       // input 2
  input         ci,         // carry in
  input         flag,       // if read carry in
  input         flip,       // if flip to subtracter
  output[7:0]   sum,        // sum
  output        co          // carry out
);

  // extra wire
  wire[7:0]     add2_flip;
  wire          ci_flag, co_flip;

  // assign wire
  assign        add2_flip = {8{flip}} ^ add2;
  assign        ci_flag = flag & ci;
  assign        ci_flip = flip ^ ci_flag;
  assign        co = flip ^ co_flip;

  assign        {co_flip, sum} = add1 + add2_flip + ci_flip;

endmodule
