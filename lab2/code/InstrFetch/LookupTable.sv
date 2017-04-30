/*****************************************************************************
  File Name:    LookupTable.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  lookup table stores 4 8-bit instr address for branching
                Take 2-bit control signal, output 8-bit address
*****************************************************************************/
module LookupTable(
  control,
  addr
);

// input
input[1:0]    control;              // 2-bit control signal

// output
output[7:0]   pc_addr;              // 8-bit pc to jump to

// TODO

endmodule
