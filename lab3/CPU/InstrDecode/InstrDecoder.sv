/*****************************************************************************
  File Name:    InstrDecoder.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  decode instruction, control state of all units
                input   instr
                output  set, branch, halt;
                        control;
                        read1, isReg1, read2, isReg2, isReg3, isWrite
                          writeReg, isRegW, writeFlip, writeFlag;
                        memOp;
                        regSrc;
*****************************************************************************/
module InstrDecode(
  input[8:0]        instr,        // 9-bit instruction code
  output reg        writeBranch,  // if take branch, & with ALU computed result
  output reg[1:0]   branch,       // 2-bit control which branch in lookup table
  output reg        halt,         // stop updating pc
  output reg[8:0]   control,      // 9-bit ALU control
  output reg[2:0]   read1,        // first output of regfile
  output reg        isReg1,       // if first output from regular register
  output reg[2:0]   read2,        // second output of regfile
  output reg        isReg2,       // if second output from regular register
  output reg        isReg3,       // if third output from $t0 (1) or $acc5 (0)
  output reg        isWrite,      // if need to write to register
  output reg[2:0]   writeReg,     // which reg to write
  output reg        isRegW,       // is reg to write reg (1) or acc (0)
  output reg[7:0]   regData,      // 8-bit to write to register
  output reg        writeFlip,    // is write to flip
  output reg        writeFlag,    // is write to flag
  output reg        memOp,        // 0 for read, 1 for write, no 2 at same time
  output reg[2:0]   regSrc        // register write Data source
                              //    000 for 0,       001 for ALUOut
                              //    010 for decode,  011 for memData
                              //    100 for read1
);

  // initialize write signal to 0
  initial begin
    writeBranch = 1'b0; isWrite = 1'b0; writeFlip = 1'b0;
    writeFlag = 1'b0; memOp = 1'b0;
  end

  // always at instr change
  always @ (instr) begin
    if (!instr[8]) begin   // set imm
      // other write control stay at 0
      writeBranch = 1'b0; halt = 1'b0; memOp = 1'b0;
      writeFlip = 1'b0; writeFlag = 1'b0; branch = 1'b0;
      // set write to $t0
      isWrite = 1'b1; isRegW = 1'b1; writeReg = 3'b000;
      // src direct from decoder
      regSrc = 3'b010; regData = instr[7:0];
      // dont cares: isReg1, isReg2, isReg3, read1, read2, constrol, branch

    end else begin        // other type instruction
      case (instr[7:2])
        6'b000000: begin  // ldm0
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          writeFlag = 1'b0; memOp = 1'b0;
          // set write to $acc0
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b000;
          // read from memory location at args
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // output memory
          regSrc = 3'b011;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b000001: begin  // ldm1
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          writeFlag = 1'b0; memOp = 1'b0;
          // set write to $acc1
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b001;
          // read from memory location at args
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // output memory
          regSrc = 3'b011;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b000010: begin  // ldm2
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          writeFlag = 1'b0; memOp = 1'b0;
          // set write to $acc2
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b010;
          // read from memory location at args
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // output memory
          regSrc = 3'b011;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b000011: begin  // ldm3
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          writeFlag = 1'b0; branch = 1'b0; memOp = 1'b0;
          // set write to $acc3
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b011;
          // read from memory location at args
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // output memory
          regSrc = 3'b011;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b000100: begin  // ldm4
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          writeFlag = 1'b0; memOp = 1'b0;
          // set write to $acc5
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b100;
          // read from memory location at args
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // output memory
          regSrc = 3'b011;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b110111: begin  // ldm5
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          writeFlag = 1'b0; memOp = 1'b0;
          // set write to $acc5
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b101;
          // read from memory location at args
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // output memory
          regSrc = 3'b011;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b000101: begin  // ldr1
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          writeFlag = 1'b0; memOp = 1'b0;
          // set write to $acc5
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b001;
          // read from args
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // output register
          regSrc = 3'b100;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b000110: begin  // ldr4
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          writeFlag = 1'b0; memOp = 1'b0;
          // set write to $acc4
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b100;
          // read from args
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // output register
          regSrc = 3'b100;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b000111: begin  // ldr5
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          writeFlag = 1'b0; memOp = 1'b0;
          // set write to $acc5
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b101;
          // read from args
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // output register
          regSrc = 3'b100;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b001000: begin  // add1
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc1
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b001;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand
          read1 = 3'b001; isReg1 = 1'b0;
          read2 = {1'b0, instr[1:0]}; isReg2 = 1'b1;
          // set constrol
          control = 9'b0000xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b001001: begin  // add4
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc4
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b100;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc4 + $t_
          read1 = 3'b100; isReg1 = 1'b0;
          read2 = {1'b0, instr[1:0]}; isReg2 = 1'b1;
          // set constrol
          control = 9'b0000xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b001010: begin  // add5
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc5
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b101;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc5 + $t_
          read1 = 3'b101; isReg1 = 1'b0;
          read2 = {1'b0, instr[1:0]}; isReg2 = 1'b1;
          // set constrol
          control = 9'b0000xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b001011: begin  // addf0
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc0
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b000;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc0 + $t_
          read1 = 3'b000; isReg1 = 1'b0;
          read2 = {1'b0, instr[1:0]}; isReg2 = 1'b1;
          // set constrol
          control = 9'b0010xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b001100: begin  // addf4
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc4
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b100;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc4 + $t_
          read1 = 3'b100; isReg1 = 1'b0;
          read2 = {1'b0, instr[1:0]}; isReg2 = 1'b1;
          // set constrol
          control = 9'b0010xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b001101: begin  // sub1
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc1
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b001;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc1 + $t_
          read1 = 3'b001; isReg1 = 1'b0;
          read2 = {1'b0, instr[1:0]}; isReg2 = 1'b1;
          // set constrol
          control = 9'b0001xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b001110: begin  // sub3
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc3
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b011;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc3 + $t_
          read1 = 3'b011; isReg1 = 1'b0;
          read2 = {1'b0, instr[1:0]}; isReg2 = 1'b1;
          // set constrol
          control = 9'b0001xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b001111: begin  // sub4
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc4
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b100;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc4 + $t_
          read1 = 3'b100; isReg1 = 1'b0;
          read2 = {1'b0, instr[1:0]}; isReg2 = 1'b1;
          // set constrol
          control = 9'b0001xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b010000: begin  // sub5
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc5
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b101;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc5 + $t_
          read1 = 3'b101; isReg1 = 1'b0;
          read2 = {1'b0, instr[1:0]}; isReg2 = 1'b1;
          // set constrol
          control = 9'b0001xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b010001: begin  // subf2
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc2
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b010;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc2 + $t_
          read1 = 3'b010; isReg1 = 1'b0;
          read2 = {1'b0, instr[1:0]}; isReg2 = 1'b1;
          // set constrol
          control = 9'b0011xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b010010: begin  // str1
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; writeFlag = 1'b0;
          // set write to $t_
          isWrite = 1'b1; isRegW = 1'b1; writeReg = {1'b0, instr[1:0]};
          // set read from $acc1
          read1 = 3'b001; isReg1 = 1'b0;
          // set $t_ from read1
          regSrc = 3'b100;
          // don't cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b010011: begin  // str2
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; writeFlag = 1'b0;
          // set write to $t_
          isWrite = 1'b1; isRegW = 1'b1; writeReg = {1'b0, instr[1:0]};
          // set read from $acc2
          read1 = 3'b010; isReg1 = 1'b0;
          // set $t_ from read1
          regSrc = 3'b100;
          // don't cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b010100: begin  // str3
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; writeFlag = 1'b0;
          // set write to $t_
          isWrite = 1'b1; isRegW = 1'b1; writeReg = {1'b0, instr[1:0]};
          // set read from $acc3
          read1 = 3'b011; isReg1 = 1'b0;
          // set $t_ from read1
          regSrc = 3'b100;
          // don't cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b010101: begin  // stm0
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          isWrite = 1'b0; writeFlag = 1'b0;
          // set write mem
          memOp = 1'b1;
          // set read from $t_
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // set data in from read2 $acc0
          read2 = 3'b000; isReg2 = 1'b0;
          // don't cares: isReg3, writeReg, isRegW, regSrc, control, regData, branch
        end
        6'b010110: begin  // stm1
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          isWrite = 1'b0; writeFlag = 1'b0;
          // set write mem
          memOp = 1'b1;
          // set read from $t_
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // set data in from read2 $acc1
          read2 = 3'b001; isReg2 = 1'b0;
          // don't cares: isReg3, writeReg, isRegW, regSrc, control, regData, branch
        end
        6'b010111: begin  // stm3
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          isWrite = 1'b0; writeFlag = 1'b0;
          // set write mem
          memOp = 1'b1;
          // set read from $t_
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // set data in from read2 $acc3
          read2 = 3'b011; isReg2 = 1'b0;
          // don't cares: isReg3, writeReg, isRegW, regSrc, control, regData, branch
        end
        6'b011000: begin  // stm4
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          isWrite = 1'b0; writeFlag = 1'b0;
          // set write mem
          memOp = 1'b1;
          // set read from $t_
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // set data in from read2 $acc4
          read2 = 3'b100; isReg2 = 1'b0;
          // don't cares: isReg3, writeReg, isRegW, regSrc, control, regData, branch
        end
        6'b011001: begin  // stm5
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          isWrite = 1'b0; writeFlag = 1'b0;
          // set write mem
          memOp = 1'b1;
          // set read from $t_
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // set data in from read2 $acc5
          read2 = 3'b101; isReg2 = 1'b0;
          // don't cares: isReg3, writeReg, isRegW, regSrc, control, regData, branch
        end
        6'b011010: begin  // mov
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          branch = 1'b0; memOp = 1'b0; writeFlag = 1'b0;
          // set write to $t_
          isWrite = 1'b1; isRegW = 1'b1; writeReg = {1'b0, instr[1:0]};
          // set source to read1 $t0
          read1 = 3'b000; isReg1 = 1'b1;
          // set reg data src from read1
          regSrc = 3'b100;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b011011: begin  // srl
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // write flag
          writeFlag = 1'b1;
          // read1 from $t_
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // result store to $t_
          isWrite = 1'b1; writeReg = {1'b0, instr[1:0]}; isRegW = 1'b1;
          // control signal
          control = 9'b1101xxxx0;
          // write source from ALUout
          regSrc = 3'b001;
          // dont cares: read2, isReg2, isReg3, regData, branch
        end
        6'b011100: begin  // sra
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // write flag
          writeFlag = 1'b1;
          // read1 from $t_
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // result store to $t_
          isWrite = 1'b1; writeReg = {1'b0, instr[1:0]}; isRegW = 1'b1;
          // control signal
          control = 9'b1100xxxx0;
          // write source from ALUout
          regSrc = 3'b001;
          // dont cares: read2, isReg2, isReg3, regData, branch
        end
        6'b011101: begin  // srf
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // write flag
          writeFlag = 1'b1;
          // read1 from $t_
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // result store to $t_
          isWrite = 1'b1; writeReg = {1'b0, instr[1:0]}; isRegW = 1'b1;
          // control signal
          control = 9'b1110xxxx0;
          // write source from ALUout
          regSrc = 3'b001;
          // dont cares: read2, isReg2, isReg3, regData, branch
        end
        6'b011110: begin  // bnzr
          // other write control stay at 0
          halt = 1'b0; writeFlag = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; isWrite = 1'b0;
          // $t0 goes to read1
          read1 = 3'b000; isReg1 = 1'b1;
          // branch true, arg is branch
          writeBranch = 1'b1; branch = instr[1:0];
          // control
          control = 9'bxxxx01xxx;
          // dont cares: read2, isReg2, isReg3, writeReg, isRegW, regData, regSrc
        end
        6'b011111: begin  // bnuzr
          // other write control stay at 0
          halt = 1'b0; writeFlag = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; isWrite = 1'b0;
          // $t0 goes to read1
          read1 = 3'b000; isReg1 = 1'b1;
          // branch true, arg is branch
          writeBranch = 1'b1; branch = instr[1:0];
          // control
          control = 9'bxxxx10xxx;
          // dont cares: read2, isReg2, isReg3, writeReg, isRegW, regData, regSrc
        end
        6'b100000: begin  // b1ne31
          // other write control stay at 0
          halt = 1'b0; writeFlag = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; isWrite = 1'b0;
          // $acc1 goes to read1
          read1 = 3'b001; isReg1 = 1'b0;
          // branch true, arg is branch
          writeBranch = 1'b1; branch = instr[1:0];
          // control
          control = 9'bxxxx11xxx;
          // dont cares: read2, isReg2, isReg3, writeReg, isRegW, regData, regSrc
        end
        6'b100001: begin  // dec1
          // other write control stay at 0
          halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0; writeBranch = 1'b0;
          // set flag
          writeFlag = 1'b1;
          // $acc1 go to read1
          read1 = 3'b001; isReg1 = 1'b0;
          // write register
          isWrite = 1'b1; writeReg = 3'b001; isRegW = 1'b0;
          // set $acc1 to ALUout
          regSrc = 3'b001;
          // control
          control = 9'b1001xx001;
          // dont cares: read2, isReg2, read3, regData, branch
        end
        6'b100010: begin  // zero0
          // other write control stay at 0
          halt = 1'b0; writeFlag = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; writeBranch = 1'b0;
          // write 0 to $acc0
          isWrite = 1'b1; writeReg = 3'b000; isRegW = 1'b0;
          // set $acc1 to 0
          regSrc = 3'b000;
          // dont cares: read1, isReg1, read2, isReg2, isReg3,
          //             regData, branch, control
        end
        6'b100011: begin  // zero2
          // other write control stay at 0
          halt = 1'b0; writeFlag = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; writeBranch = 1'b0;
          // write 0 to $acc2
          isWrite = 1'b1; writeReg = 3'b010; isRegW = 1'b0;
          // set $acc1 to 0
          regSrc = 3'b000;
          // dont cares: read1, isReg1, read2, isReg2, isReg3,
          //             regData, branch, control
        end
        6'b100100: begin  // zero3
          // other write control stay at 0
          halt = 1'b0; writeFlag = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; writeBranch = 1'b0;
          // write 0 to $acc3
          isWrite = 1'b1; writeReg = 3'b011; isRegW = 1'b0;
          // set $acc1 to 0
          regSrc = 3'b000;
          // dont cares: read1, isReg1, read2, isReg2, isReg3,
          //             regData, branch, control
        end
        6'b100101: begin  // zero4
          // other write control stay at 0
          halt = 1'b0; writeFlag = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; writeBranch = 1'b0;
          // write 0 to $acc2
          isWrite = 1'b1; writeReg = 3'b100; isRegW = 1'b0;
          // set $acc1 to 0
          regSrc = 3'b000;
          // dont cares: read1, isReg1, read2, isReg2, isReg3,
          //             regData, branch, control
        end
        6'b100110: begin  // srl4
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // write flag
          writeFlag = 1'b1;
          // read1 from $acc4
          read1 = 3'b100; isReg1 = 1'b0;
          // result store to $acc4
          isWrite = 1'b1; writeReg = 3'b100; isRegW = 1'b0;
          // control signal
          control = 9'b1101xxxx0;
          // write source from ALUout
          regSrc = 3'b001;
          // dont cares: read2, isReg2, isReg3, regData, branch
        end
        6'b100111: begin  // srl5
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // write flag
          writeFlag = 1'b1;
          // read1 from $acc5
          read1 = 3'b101; isReg1 = 1'b0;
          // result store to $acc5
          isWrite = 1'b1; writeReg = 3'b101; isRegW = 1'b0;
          // control signal
          control = 9'b1101xxxx0;
          // write source from ALUout
          regSrc = 3'b001;
          // dont cares: read2, isReg2, isReg3, regData, branch
        end
        6'b101000: begin  // srf5
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // write flag
          writeFlag = 1'b1;
          // read1 from $acc5
          read1 = 3'b101; isReg1 = 1'b0;
          // result store to $acc5
          isWrite = 1'b1; writeReg = 3'b101; isRegW = 1'b0;
          // control signal
          control = 9'b1110xxxx0;
          // write source from ALUout
          regSrc = 3'b001;
          // dont cares: read2, isReg2, isReg3, regData, branch
        end
        6'b101001: begin  // slf0
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // write flag
          writeFlag = 1'b1;
          // read1 from $acc0
          read1 = 3'b000; isReg1 = 1'b0;
          // result store to $acc0
          isWrite = 1'b1; writeReg = 3'b000; isRegW = 1'b0;
          // control signal
          control = 9'b1111xxxx0;
          // write source from ALUout
          regSrc = 3'b001;
          // dont cares: read2, isReg2, isReg3, regData, branch
        end
        6'b101010: begin  // slf1
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // write flag
          writeFlag = 1'b1;
          // read1 from $acc1
          read1 = 3'b001; isReg1 = 1'b0;
          // result store to $acc1
          isWrite = 1'b1; writeReg = 3'b001; isRegW = 1'b0;
          // control signal
          control = 9'b1111xxxx0;
          // write source from ALUout
          regSrc = 3'b001;
          // dont cares: read2, isReg2, isReg3, regData, branch
        end
        6'b101011: begin  // slf2
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // write flag
          writeFlag = 1'b1;
          // read1 from $acc2
          read1 = 3'b010; isReg1 = 1'b0;
          // result store to $acc2
          isWrite = 1'b1; writeReg = 3'b010; isRegW = 1'b0;
          // control signal
          control = 9'b1111xxxx0;
          // write source from ALUout
          regSrc = 3'b001;
          // dont cares: read2, isReg2, isReg3, regData, branch
        end
        6'b101100: begin  // atos_2
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlag = 1'b0;
          memOp = 1'b0; isWrite = 1'b0;
          // read1 from $acc2
          read1 = 3'b010; isReg1 = 1'b0;
          // set flip
          writeFlip = 1'b1;
          // dont cares: read2, isReg2, isReg3, regData, branch
          //             writeReg, isRegW, control, regSrc
        end
        6'b101101: begin  // add3_n2
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; memOp = 1'b0; writeFlip = 1'b0;
          // write to $acc3
          writeFlag = 1'b1; isWrite = 1'b1;
          writeReg = 3'b011; isRegW = 1'b0;
          // read1 from $acc3
          read1 = 3'b011; isReg1 = 1'b0;
          // read2 from $acc2
          read2 = 3'b010; isReg2 = 1'b0;
          // read3 from $t0
          isReg3 = 1'b1;
          // control
          control = 9'b0000xx011;
          // regSrc from ALUout
          regSrc = 3'b001;
          // dont cares: branch, regData
        end
        6'b101110: begin  // add4_n2
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; memOp = 1'b0; writeFlip = 1'b0;
          // write to $acc4
          writeFlag = 1'b1; isWrite = 1'b1;
          writeReg = 3'b100; isRegW = 1'b0;
          // read1 from $acc4
          read1 = 3'b100; isReg1 = 1'b0;
          // read2 from $acc2
          read2 = 3'b010; isReg2 = 1'b0;
          // read3 from $t0
          isReg3 = 1'b1;
          // control
          control = 9'b0000xx011;
          // regSrc from ALUout
          regSrc = 3'b001;
          // dont cares: branch, regData
        end
        6'b101111: begin  // cp0_5
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          branch = 1'b0; memOp = 1'b0; writeFlag = 1'b0;
          // set write to $acc5
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b101;
          // set source to read1 $acc0
          read1 = 3'b000; isReg1 = 1'b0;
          // set reg data src from read1
          regSrc = 3'b100;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b110000: begin  // add25
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc1
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b010;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc2 + $acc5
          read1 = 3'b010; isReg1 = 1'b0;
          read2 = 3'b101; isReg2 = 1'b0;
          // set constrol
          control = 9'b0000xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b110001: begin  // sub25
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc1
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b010;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc2 + $acc5
          read1 = 3'b010; isReg1 = 1'b0;
          read2 = 3'b101; isReg2 = 1'b0;
          // set constrol
          control = 9'b0001xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b110010: begin  // subf25
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc1
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b010;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc2 + $acc5
          read1 = 3'b010; isReg1 = 1'b0;
          read2 = 3'b101; isReg2 = 1'b0;
          // set constrol
          control = 9'b0011xx000;
          // don't cares: isReg3, regData, branch
        end
        6'b110011: begin  // inc_af0
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc0
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b000;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc0
          read1 = 3'b000; isReg1 = 1'b0;
          // set constrol
          control = 9'b0000xx111;
          // don't cares: read2, isReg2, isReg3, regData, branch
        end
        6'b110100: begin  // add0c25
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // set write to $acc0
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b000;
          // set flag
          writeFlag = 1'b1;
          // set ALUout to $acc1
          regSrc = 3'b001;
          // set operand $acc0, $acc2, $acc5
          read1 = 3'b000; isReg1 = 1'b0;
          read2 = 3'b010; isReg2 = 1'b0;
          isReg3 = 1'b0;
          // set constrol
          control = 9'b0000xx101;
          // don't cares: read2, isReg2, isReg3, regData, branch
        end
        6'b110101: begin  // ld4m1
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          writeFlag = 1'b0; memOp = 1'b0;
          // set write to $acc4
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b100;
          // read from memory location at $acc1
          read1 = 3'b001; isReg1 = 1'b0;
          // output memory
          regSrc = 3'b011;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b110110: begin  // halt
          halt = 1'b1;
          // disable all write
          writeBranch = 1'b0; isWrite = 1'b0; writeFlip = 1'b0;
          writeFlag = 1'b0; memOp = 1'b0;
        end
        6'b111000: begin // dup0
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          branch = 1'b0; memOp = 1'b0; writeFlag = 1'b0;
          // set write to $dup
          isWrite = 1'b1; isRegW = 1'b0; writeReg = 3'b110;
          // set source to read1 $t0
          read1 = 3'b000; isReg1 = 1'b1;
          // set reg data src from read1
          regSrc = 3'b100;
          // dont cares: read2, isReg2, isReg3, control, regData, branch
        end
        6'b111001: begin // slld
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // write flag
          writeFlag = 1'b1;
          // read1 from $dup
          read1 = 3'b110; isReg1 = 1'b0;
          // result store to $dup
          isWrite = 1'b1; writeReg = 3'b110; isRegW = 1'b0;
          // control signal
          control = 9'b0111xxxxx;
          // write source from ALUout
          regSrc = 3'b001;
          // dont cares: read2, isReg2, isReg3, regData, branch
        end
        6'b111010: begin // bnzd
          // other write control stay at 0
          halt = 1'b0; writeFlag = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; isWrite = 1'b0;
          // $dup goes to read1
          read1 = 3'b110; isReg1 = 1'b0;
          // branch true, arg is branch
          writeBranch = 1'b1; branch = instr[1:0];
          // control
          control = 9'bxxxx01xxx;
          // dont cares: read2, isReg2, isReg3, writeReg, isRegW, regData, regSrc
        end
        6'b111011: begin // srfc2
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0; memOp = 1'b0;
          // write flag
          writeFlag = 1'b1;
          // read1 from $t_
          read1 = {1'b0, instr[1:0]}; isReg1 = 1'b1;
          // read2 from $acc2
          read2 = 3'b010; isReg2 = 1'b0;
          // result store to $t_
          isWrite = 1'b1; writeReg = {1'b0, instr[1:0]}; isRegW = 1'b1;
          // control signal
          control = 9'b1110xxxx1;
          // write source from ALUout
          regSrc = 3'b001;
          // dont cares: read2, isReg2, isReg3, regData, branch
        end
        6'b111100: begin // str0
          // other write control stay at 0
          writeBranch = 1'b0; halt = 1'b0; writeFlip = 1'b0;
          memOp = 1'b0; writeFlag = 1'b0;
          // set write to $t_
          isWrite = 1'b1; isRegW = 1'b1; writeReg = {1'b0, instr[1:0]};
          // set read from $acc0
          read1 = 3'b000; isReg1 = 1'b0;
          // set $t_ from read1
          regSrc = 3'b100;
          // don't cares: read2, isReg2, isReg3, control, regData, branch
        end
      endcase
    end
  end
endmodule
