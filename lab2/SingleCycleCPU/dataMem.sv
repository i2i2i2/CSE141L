/*****************************************************************************
  File Name:    dataMem.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  input: CLK, DataAddress, ReadMem, WriteMem, DataIn
				output: DataOut
*****************************************************************************/
module dataMem(
  input[7:0]    addr,             // input address for read or write
  input[7:0]    dataIn,           // input data
  input         memOp,            // 1 for write 0 for read
  input         CLK,
  output[7:0]   dataOut           // output data
);
  // data memory
  reg[7:0]      mem[0: 255];
  integer       idx;              // for dump

  // always output
  assign        dataOut = mem[addr];

  // write on posedge
  always @(posedge CLK) begin
    if(memOp) begin  // write memory
      mem[addr] <= dataIn;
    end
  end

  // initial
  initial begin
    $dumpfile("mem.vcd");
    for (idx = 0; idx < 256; idx++)
      $dumpvars(0, mem[idx]);

    $readmemh("mem", mem);
  end

endmodule
