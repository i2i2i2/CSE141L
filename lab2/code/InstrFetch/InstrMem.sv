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
  input[7:0] pc,                         // pc value 8-bit
  output[8:0] Instr                       // machine code at position; 9-bit instruction code
);

logic[8:0] inst_mem[255]				 //ROM array to initialize all of the elements  
assign instr = inst_mem[pc]   		 	 //read from the address


endmodule
