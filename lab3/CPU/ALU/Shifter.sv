/*****************************************************************************
  File Name:    Shifter.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  shifter, save overflow in unclocked register
                Input   val, sel(isRight, isLogical, isReadf) flag
                Output  shifted, flagout
*****************************************************************************/
module Shifter(
  input[7:0]    val,              // input value
  input[1:0]    sel,              // input seletion signal
  input         flag,             // input overflow bit
  output[7:0]   shifted,          // output shifted value
  output        flagout           // output overflow bit
);

  wire[7:0]     shifts[0:3];      // 6 different shifts

  // assign wire
  assign        shifts[0] = {val[7], val[7:1]}; // sra 000
  assign        shifts[1] = {1'b0, val[7:1]};   // srl 001
  assign        shifts[2] = {flag, val[7:1]};   // srf 010
  assign        shifts[3] = {val[6:0], flag};   // slf 011

  assign        shifted = shifts[sel];
  assign        flagout = (&sel)? val[7] : val[0];

endmodule
