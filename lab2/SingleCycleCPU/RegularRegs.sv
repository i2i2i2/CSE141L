/*****************************************************************************
  File Name:    RegularRegs.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  4 regular
                Input   read1, read2, isWrite, writeReg, writeData, CLK
                Output  reg1, reg2
*****************************************************************************/
module RegularRegs(
  input[1:0]    read1,        // 2-bit read1
  input[1:0]    read2,        // 2-bit read2
  input         isWrite,      // need write?
  input[1:0]    writeReg,     // 2-bit reg to write to
  input[7:0]    writeData,    // 8-bit data to write
  input         CLK,
  output[7:0]   reg1,         // output read1
  output[7:0]   reg2,         // output read2
  output[7:0]   reg3          // always output $t0
);

// regs
reg[7:0]      registers[0:3];

// always read
assign        reg1 = registers[read1];
assign        reg2 = registers[read2];
assign        reg3 = registers[0];

// clocked write
always @(posedge CLK) begin
  if (isWrite) begin
    registers[writeReg] <= writeData;
  end
end

endmodule
