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
  input[7:0]    pc,                     // pc value 8-bit
  output[8:0]   instr                   // machine code at pc
);

  reg[8:0]      instrMem[0:255];        // ROM array
  assign        instr = instrMem[pc];   //read from the address

  initial begin
    $readmemh("instr", instrMem);
  end

endmodule
