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
  input     writeFlip,    // if write the flip bit
  input     writeFlag,    // if write the flag bit
  input     CLK,
  output    flipout,      // output flip
  output    flagout       // output flag
);

  reg       flag, flip;

  // always output
  assign    flagout = flag;
  assign    flipout = flip;

  always @(posedge CLK) begin
    if (writeFlag) begin
      flag <= flagin;
    end
    if (writeFlip) begin
      flip <= flipin;
    end
  end

  // initial
  initial begin
    flag = 1'b0;
    flip = 1'b0;

    $dumpfile("reg.vcd");
    $dumpvars(0, flag);
    $dumpvars(0, flip);
  end

endmodule
