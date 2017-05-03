/*****************************************************************************
  File Name:    AccumulatorRegs_tb.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  6 accumulators, testbench
                Input   read1, read2, isWrite, writeReg, writeData, CLK
                Output  acc1, acc2
*****************************************************************************/
`timescale 1ns/100ps
`include "AccumulatorRegs.sv"

module AccumulatorRegs_tb;

  reg         isWrite, CLK;
  reg[2:0]    read1, read2, writeReg;
  reg[7:0]    writeData;
  wire[7:0]   acc1, acc2;

  AccumulatorRegs testAccReg(read1, read2, isWrite, writeReg, writeData, CLK, acc1, acc2);

  initial begin

    $dumpfile("AccumulatorRegsTest.vcd");
    $dumpvars(0, AccumulatorRegs_tb);

    #10;
    read1 = 3'b000;  isWrite = 1'b0; writeReg = 3'b000; writeData = 8'b10101010;

    #10;
    isWrite = 1'b1;

    #10;
    read1 = 3'b000; writeReg = 3'b000; writeData = 8'b11110000;

    #10;
    read2 = 3'b010; writeReg = 3'b010; writeData = 8'b00001111;

    #10;
    isWrite = 1'b0; writeData = 8'b00000000;

    #10;
    writeReg = 3'b001; isWrite = 1'b1; writeData = 8'b11111111; read1 = 3'b001;

    #10;

    #10;
    read1 = 3'b000;
    $finish;
  end

  always begin
    #5   CLK = 0;
    #5   CLK = 1;
  end

endmodule
