/*****************************************************************************
  File Name:    SingleBitRegs.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  2 single-bit
                Input   flipin, flagin, CLK
                Output  flipout, flagout
*****************************************************************************/
module SingleBitRegs (
  input     flipin,       // flip to update
  input     flagin,       // flag to update
  input     bitin,        // bit to update
  input     writeFlip,    // if write the flip bit
  input     writeFlag,    // if write the flag bit
  input     writeBit,     // if write the bit
  input     CLK,
  output    flipout,      // output flip
  output    flagout,      // output flag
  output    bitout        // output bit
);

  reg       flag, flip, onebit;

  // always output
  assign    flagout = flag;
  assign    flipout = flip;
  assign    bitout = onebit;

  always @(posedge CLK) begin
    if (writeFlag) begin
      flag <= flagin;
    end
    if (writeFlip) begin
      flip <= flipin;
    end
    if (writeBit && bitin) begin
      onebit <= bitin;
    end
  end

  // initial
  initial begin
    flag = 1'b0;
    flip = 1'b0;
    onebit = 1'b0;

    $dumpfile("cpu.vcd");
    $dumpvars(0, flag);
    $dumpvars(0, flip);
    $dumpvars(0, onebit);
  end

endmodule
