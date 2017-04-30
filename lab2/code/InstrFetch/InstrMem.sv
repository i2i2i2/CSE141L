/*****************************************************************************
  File Name:    InstrMem.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  Instruction memory
                Input   program counter value
                output  Instruction bit code at position
*****************************************************************************/
module InstrMem (
  pc,                         // pc value
  Instr                       // machine code at position
);

// inputs
input[7:0]  pc;               // 8-bit pc

// outputs
output[8:0] instr;            // 9-bit instruction code

// TODO

endmodule
