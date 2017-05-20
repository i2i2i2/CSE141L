/*****************************************************************************
  File Name:    AccumulatorRegs.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  6 accumulators
                Input   read1, read2, isWrite, writeReg, writeData, CLK
                Output  acc1, acc2
*****************************************************************************/
module AccumulatorRegs(
  input[2:0]    read1,      // 3-bit acc addr1
  input[2:0]    read2,      // 3-bit acc addr2
  input         isWrite,    // do we need write
  input[2:0]    writeReg,   // 3-bit acc addr to write
  input[7:0]    writeData,  // 8-bit data to write to
  input         CLK,
  output[7:0]   acc1,       // data at addr1
  output[7:0]   acc2,       // data at addr2
  output[7:0]   acc3        // data in $acc5 always outputting
);

  // regs
  reg[7:0]      accumulators[0:7];
  integer       idx;

  // always read
  assign        acc1 = accumulators[read1];
  assign        acc2 = accumulators[read2];
  assign        acc3 = accumulators[5];

  // clocked write
  always @(posedge CLK) begin
    if (isWrite) begin
      accumulators[writeReg] <= writeData;
    end
  end

  // initial
  initial begin
    $dumpfile("cpu.vcd");
    for (idx = 0; idx < 6; idx++)
      $dumpvars(0, accumulators[idx]);
  end

endmodule
