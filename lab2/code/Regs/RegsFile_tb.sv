/*****************************************************************************
  File Name:    RegsFile_tb.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  Register file, testbench
                Input   read1, isReg1, read2, isReg2, isWrite, writeReg,
                        writeData, isRegW, flipin, flagin, CLK
                Output  reg1, reg2, flagOut, flipOut
*****************************************************************************/
`timescale 1ns/100ps
`include "RegsFile.sv"

module RegsFile_tb;

  reg[7:0]    writeData;
  reg[2:0]    read1, read2, writeReg;
  reg         isReg1, isReg2, isWrite, isRegW, flipin, flagin, writeFlip,
              writeFlag, CLK, isReg3;
  wire[7:0]   reg1, reg2, reg3;
  wire        flipout, flagout;

  RegsFile registers(read1, isReg1, read2, isReg2, isReg3, isWrite, writeReg,
        writeData, isRegW, flipin, writeFlip, flagin, writeFlag, CLK,
        reg1, reg2, reg3, flipout, flagout);

  initial begin

    $dumpfile("registerTest.vcd");
    $dumpvars(0, RegsFile_tb);

    #10;    // write to and read from Acc
    read1 = 3'b000; isReg1 = 1'b0; isWrite = 1'b1; writeReg = 3'b000;
    isRegW = 1'b0; writeData = 8'b01101001;
    $strobe("Write to Acc0, $acc0 = %b (01101001)", reg1);

    #10;    // check Reg not contaminate
    isReg1 = 1'b1;
    $strobe("$reg0 should not change, $reg0 = %b (xxxx)", reg1);

    #10;    // write to and read from reg
    read2 = 3'b001; isReg2 = 1'b1; isWrite = 1'b1; writeReg = 3'b001;
    isRegW = 1'b1; writeData = 8'b11110000; isReg1 = 1'b0;
    $strobe("Write to reg1, $reg1 = %b (11110000), $acc0 = %b (01101001)", reg2, reg1);

    #10;    // check Reg not contaminate
    isReg2 = 1'b0;
    $strobe("$acc1 should not change, $acc1 = %b (xxxx)", reg2);

    #10;    // disable write
    isRegW = 1'b0; writeData = 8'b00001111; isWrite = 1'b0;
    $strobe("$acc1 should not change, $acc1 = %b (xxxx)", reg2);

    #10;    // write to and read from flip
    flipin = 1'b1; writeFlip = 1'b1;
    $strobe("$flip = %b (1), $flag = %b (x)", flipout, flagout);

    #10;    // disable write
    flipin = 1'b0; writeFlip = 1'b0;
    $strobe("Should not change $flip = %b (1), $flag = %b (x)", flipout, flagout);

    #10;    // write to acc5, check reg3
    isReg3 = 1'b0; writeReg = 3'b101; writeData = 8'b10110100; isRegW = 1'b0; isWrite = 1'b1;
    $strobe("reg3 = %b (10110100)", reg3);

    #10;    // write to acc5, check reg3
    isReg3 = 1'b1; writeReg = 3'b000; writeData = 8'b11111100; isRegW = 1'b1;
    $strobe("reg3 = %b (11111100)", reg3);

    #10;
    $finish;
  end

  always begin
    #5    CLK = 0;
    #5    CLK = 1;
  end

endmodule
