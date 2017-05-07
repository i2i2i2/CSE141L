/*****************************************************************************
  File Name:    ALU_tb.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  ALU
                Input   srcA, srcB, srcC, flagin, flipin, control
                output  result, flagout, flipout, branch
                control
                  8     use 1 as second operand
                  7     add or shift
                  6-5   add or shift's control
                    for shifter
                        00-11  sra, srl, srf, slf
                    for adder
                        6 - if take flag
                        5 - if add or sub
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
`timescale 1ns / 100ps
`include "ALU.sv"

module ALU_tb;

  reg[7:0]    srcA, srcB, srcC;
  reg[8:0]    control;
  reg         flagin, flipin;
  wire[7:0]   result;
  wire        flagout, flipout, branch;

  ALU testALU(srcA, srcB, srcC, flagin, flipin, control,
      result, flagout, flipout, branch);

  initial begin

    $dumpfile("ALUTest.vcd");
    $dumpvars(0, ALU_tb);

    /* test adder */
    #10;    // add 2 number no overflow;
    srcA = 8'b00111111; srcB = 8'b01010101; flagin = 1'b0; flipin = 1'b0;
    control = 9'b0010xx000;
    $strobe("00111111 + 00000001 + 0 = %b %b (0 10010100)", flagout, result);

    #10;    // add 2 number, overflow + carry in
    srcA = 8'b11111111; srcB = 8'b00000000; flagin = 1'b1; flipin = 1'b1;
    control = 9'b0010xx001;
    $strobe("11111111 + 00000000 + 1 = %b %b (1 00000000)", flagout, result);

    #10;    // minus number, not borrow
    srcA = 8'b11111111; srcB = 8'b00001110; flagin = 1'b1; flipin = 1'b0;
    control = 9'b0001xx000;
    $strobe("11111111 - 00001110 - 0 = %b %b (0 11110001)", flagout, result);

    #10;    // minus number, borrow
    srcA = 8'b00000000; srcB = 8'b00000000; flagin = 1'b1; flipin = 1'b1;
    control = 9'b0010xx000;
    $strobe("00000000 - 00000000 - 1 = %b %b (1 11111111)", flagout, result);

    #10;    // more borrow test
    srcA = 8'b00000000; srcB = 8'b11111111; flagin = 1'b0; flipin = 1'b0;
    control = 9'b0011xx000;
    $strobe("00000000 - 11111111 - 0 = %b %b (1 00000001)", flagout, result);

    #10;    // add 1 test
    srcA = 8'b00000000; srcB = 8'b11111111; flagin = 1'b0; flipin = 1'b1;
    control = 9'b1000xx001;
    $strobe("00000000 + 11111111 (00000001) + 0 = %b %b (0 00000001)", flagout, result);

    /* shifter test */
    #10;
    srcA = 8'b10000001; flagin = 1'b0;
    control = 9'bx100xxxxx;
    $strobe("1 10000001 >>> 1 = %b %b (11000000 1)", result, flagout);

    #10;
    srcA = 8'b10000001; flagin = 1'b0;
    control = 9'bx101xxxxx;
    $strobe("1 10000001 >> 1 = %b %b (01000000 1)", result, flagout);

    #10;
    srcA = 8'b00000001; flagin = 1'b1;
    control = 9'bx110xxxxx;
    $strobe("1 00000001 >> 1 = %b %b (10000000 1)", result, flagout);

    #10;
    srcA = 8'b10000001; flagin = 1'b1;
    control = 9'bx111xxxxx;
    $strobe("10000001 1 << 1 = %b %b (1 00000011)", flagout, result);

    /* test branch */
    #10;
    srcA = 8'bxxxxxxxx; control = 9'bxxxx00xxx;
    $strobe("Never branch: %b (0)", branch);

    #10;
    srcA = 8'b00000000; control = 9'bxxxx01xxx;
    $strobe("When srcA != 0, branch: %b (0)", branch);

    #10;
    srcA = 8'b01000000; control = 9'bxxxx01xxx;
    $strobe("When srcA != 0, branch: %b (1)", branch);

    #10;
    srcA = 8'b0000xxxx; control = 9'bxxxx10xxx;
    $strobe("When upper 4 bit srcA != 0, branch: %b (0)", branch);

    #10;
    srcA = 8'b0001xxxx; control = 9'bxxxx10xxx;
    $strobe("When upper 4 bit srcA != 0, branch: %b (1)", branch);

    #10;
    srcA = 8'b11111111; control = 9'bxxxx11xxx;
    $strobe("When srcA != 31, branch: %b (1)", branch);

    #10;
    srcA = 8'b00011111; control = 9'bxxxx11xxx;
    $strobe("When srcA != 31, branch: %b (0)", branch);

    /* test special add */
    #10;
    srcA = 8'b00000000; srcB = 8'b00000000; srcC = 8'b10101010; control = 9'b0000xx011;
    $strobe("00000000 + (00000000 < 0? 0: 10101010) = %b (10101010)", result);

    #10;
    srcA = 8'b00000000; srcB = 8'b10000000; srcC = 8'b10101010; control = 9'b0000xx011;
    $strobe("00000000 + (10000000 < 0? 0: 10101010) = %b (00000000)", result);

    #10;
    srcA = 8'b00000000; srcB = 8'b10100000; srcC = 8'b10101111; control = 9'b0000xx101;
    $strobe("00000000 + (10100000 upper 4 == 10101111? 0: 1) = %b (00000001)", result);

    #10;
    srcA = 8'b00000000; srcB = 8'b10111111; srcC = 8'b10101111; control = 9'b0000xx101;
    $strobe("00000000 + (10111111 upper 4 == 10101111? 0: 1) = %b (00000000)", result);

    #10;
    srcA = 8'b00000000; flipin = 0; flagin = 1; control = 9'b0000xx111;
    $strobe("00000000 + 0^1 = %b (000000001)", result);

    #10;
    srcA = 8'b00000000; flipin = 0; flagin = 0; control = 9'b0000xx111;
    $strobe("00000000 + 0^0 = %b (000000000)", result);

    #10;
    srcA = 8'b00000000; flipin = 1; flagin = 1; control = 9'b0000xx111;
    $strobe("00000000 + 1^1 = %b (000000000)", result);

    #10;
    $finish;
  end
endmodule
