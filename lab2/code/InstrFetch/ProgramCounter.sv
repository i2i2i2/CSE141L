/*****************************************************************************
  File Name:    ProgramCounter.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  Program Counter
                Input   branchAddr, halt, init, isBranch, CLK
                Output  pcAddr
*****************************************************************************/
module ProgramCounter (
  input[7:0]    branchAddr,       // possible branch addr to take
  input         halt,             // freeze pc if true
  input         init,             // start pc at 0
  input         isBranch,         // if take the branch
  input         CLK,
  output[7:0]   pcAddr            // output address
);

  reg[7:0]      pcAddr;           // internally store as addr

  always @(posedge CLK) begin
    if(init) begin                // init
      pc_addr <= 0;

    end else if(halt) begin       // halt
      pc_addr <= pc_addr;

    end else if(isBranch) begin   // take branch
      pc_addr <= branchAddr;

    end else begin                //increment
      pc_addr <= pc_addr + 1;
    end
  end
endmodule
