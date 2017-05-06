/*****************************************************************************
  File Name:    Adder_tb.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  adder, check if flip is set, turn to subtracter
                Input   a, b, ci, flip
                Output  sum, co
*****************************************************************************/
`timescale 1ns/100ps
`include "Adder.sv"

module Adder_tb;

  reg[7:0]    add1, add2;
  reg         ci, flag, flip;
  wire[7:0]   sum;
  wire        co;

  Adder testAdder(add1, add2, ci, flag, flip, sum, co);

  initial begin

    $dumpfile("adderTest.vcd");
    $dumpvars(0, Adder_tb);

    #10;    // add 2 number, no overflow
    add1 = 8'b00111111; add2 = 8'b01010101; ci = 1'b0; flag = 1'b0; flip = 1'b0;
    $strobe("00111111 + 00000001 + 0 = %b %b (0 10010100)", co, sum);

    #10;    // add 2 number, overflow + carry in
    add1 = 8'b11111111; add2 = 8'b00000000; ci = 1'b1; flag = 1'b1; flip = 1'b0;
    $strobe("11111111 + 00000000 + 1 = %b %b (1 00000000)", co, sum);

    #10;    // minus number, no borrow
    add1 = 8'b11111111; add2 = 8'b00001110; ci = 1'b1; flag = 1'b0; flip = 1'b1;
    $strobe("11111111 - 00001110 - 0 = %b %b (0 11110001)", co, sum);

    #10;    // minus number, borrow
    add1 = 8'b00000000; add2 = 8'b00000000; ci = 1'b1; flag = 1'b1; flip = 1'b1;
    $strobe("00000000 - 00000000 - 1 = %b %b (1 11111111)", co, sum);

    #10;    // more borrow test
    add1 = 8'b00000000; add2 = 8'b11111111; ci = 1'b0; flag = 1'b1; flip = 1'b1;
    $strobe("00000000 - 11111111 - 0 = %b %b (1 00000001)", co, sum);

    #10;
    $finish;
  end

endmodule
