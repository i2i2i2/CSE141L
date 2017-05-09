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
  input         init,             // initialize
  input         isBranch,         // if take the branch
  input         CLK,
  output  reg[7:0]  pcAddr        // output address
);

  always @(posedge CLK) begin
    if(init) begin                // init
      pcAddr <= 0;

    end else if(halt) begin       // halt
      pcAddr <= pcAddr;

    end else if(isBranch) begin   // take branch
      pcAddr <= branchAddr;

    end else begin                //increment
      pcAddr <= pcAddr + 1;
    end
  end
endmodule
