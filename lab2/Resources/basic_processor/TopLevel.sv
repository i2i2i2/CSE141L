//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:37:58 02/16/2012 
// Design Name: 
// Module Name:    TopLevel 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TopLevel(
    input     start,
	input     CLK,
    output    halt,
	output [ 3:0] write_register,
    output [15:0] regWriteValue,
    output        REG_WRITE,
    output [15:0] memWriteValue,
    output        MEM_WRITE,
    output [ 7:0] PC,
	output        BRANCH,
    output logic [15:0] InstCounter,
	output  [9:0] Instruction
    );

	// control signals not defined as outputs
	 wire MEM_READ,REG_DST,MEM_TO_REG,HALT;
	 wire [1:0] ALU_OP;
	 wire [1:0] ALU_SRC_B;
	 // ALU outputs
	 wire ZERO, EQUAL;
	 wire [15:0] ALUOut;
	 
	 // Data mem wires
	 wire [15:0] MemOut;
	 
	 // IF module inputs
	 wire [15:0] Target;
	 
	 // Register File
	 
	 wire [15:0] ReadA;
	 wire [15:0] ReadB;
	 	 
	 // ALU wires
	 wire [15:0] SE_Immediate;
	 wire [15:0] IntermediateMux;
	 wire [15:0] ALUInputB;

	 // manage the write register and write data muxes
	 assign write_register = (REG_DST==1)?{1'b0,Instruction[2:0]}:{1'b0,Instruction[5:3]};
	 //assign regWriteValue = (MEM_TO_REG==1)?ALUOut:MemOut;
	 assign regWriteValue = ALUOut;
	 
	 // manage ALU SRC MUX
	 assign SE_Immediate = {{13{Instruction[2]}}, Instruction[2:0]};
	 assign IntermediateMux = (ALU_SRC_B==2'b01)?SE_Immediate:ReadB;
	 assign ALUInputB = (ALU_SRC_B==2'b10)?0  : IntermediateMux;
	 
	 // assign input to memory
	 assign memWriteValue = ReadB;
	 
	 // Fetch Module (really just PC, we could have incorporated InstRom here as well)
	 IF if_module (
		.Branch  (BRANCH & ZERO), 
		.Target  ({5'b00000,Instruction[2:0]}), 
		.Init    (start), 
		.Halt    (halt), 
		.CLK          , 
		.PC
	);

	// instruction ROM
	InstROM inst_module(
	.InstAddress   (PC), 
	.InstOut       (Instruction)
	);

	// Control module
	Control control_module (
		.OPCODE(Instruction[9:6]), 
		.ALU_OP               , 
		.ALU_SRC_B            , 
		.REG_WRITE            , 
		.BRANCH               , 
		.MEM_WRITE            , 
		.MEM_READ             , 
		.REG_DST              , 
		.MEM_TO_REG           , 
		.HALT(halt)
	);


	reg_file register_module (
		.CLK                  , 
		.RegWrite  (REG_WRITE), 
		.srcA      ({1'b0,Instruction[5:3]}), //concatenate with 0 to give us 4 bits
		.srcB      ({1'b0,Instruction[2:0]}), 
		.writeReg  (write_register), 	  // mux above
		.writeValue(regWriteValue) , 
		.ReadA                     , 
		.ReadB
	);
	
		ALU ALU_Module (
		.OP    (ALU_OP) , 
		.INPUTA(ReadA)  , 
		.INPUTB(ALUInputB), 
		.OUT   (ALUOut)  , 
		.ZERO            , 
		.EQUAL (EQ)
	);

	DataRAM Data_Module(
		.DataAddress  (ReadA), 
		.ReadMem      (MEM_READ), 
		.WriteMem     (MEM_WRITE), 
		.DataIn       (memWriteValue), 
		.DataOut      (MemOut), 
		.CLK 
	);
	
	// might help debug
	/*
	always@(SE_Immediate)
	begin
	$display("SE Immediate = %d",SE_Immediate);
	end
	*/
	
	always@(posedge CLK)
	if (start == 1)
		InstCounter <= 0;
	else if(halt == 0)
		InstCounter <= InstCounter+1;



endmodule
