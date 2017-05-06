/*****************************************************************************
  File Name:    Shifter_tb.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  shifter, save overflow in unclocked register
                Input   val, sel(isRight, isLogical, isReadf) flag
                Output  shifted, flagout
*****************************************************************************/
`timescale 1ns/100ps
`include "Shifter.sv"

module Shifter_tb;

  reg[7:0]    val;
  reg[1:0]    sel;
  reg         flag;
  wire[7:0]   shifted;
  wire        flagout;

  Shifter testShifter(val, sel, flag, shifted, flagout);

  initial begin
    #10;      // test sra
    val = 8'b10000001; sel = 2'b00; flag = 1'b0;
    $strobe("1 10000001 >>> 1 = %b %b (11000000 1)", shifted, flagout);

    #10;      // test srl
    val = 8'b10000001; sel = 2'b01; flag = 1'b0;
    $strobe("1 10000001 >> 1 = %b %b (01000000 1)", shifted, flagout);

    #10;      // test srl
    val = 8'b00000001; sel = 2'b10; flag = 1'b1;
    $strobe("1 00000001 >> 1 = %b %b (10000000 1)", shifted, flagout);

    #10;      // test slf
    val = 8'b10000001; sel = 2'b11; flag = 1'b1;
    $strobe("10000001 1 << 1 = %b %b (1 00000011)", flagout, shifted);

    #10;
    $finish;
  end
endmodule
