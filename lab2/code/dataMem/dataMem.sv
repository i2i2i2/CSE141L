/*****************************************************************************
  File Name:    dataMem.sv
  Author:       Chenxu Jiang
                DingCheng Hu
  Date:         Apr 29, 2017
  Description:  input: CLK, DataAddress, ReadMem, WriteMem, DataIn
				output: DataOut
*****************************************************************************/


module data_mem(
  input              CLK,
  input [7:0]        DataAddress,
  input              ReadMem,
  input              WriteMem,
  input [7:0]       DataIn,
  output logic[7:0] DataOut);

  logic [7:0] my_memory [256];

//  initial 
//    $readmemh("dataram_init.list", my_memory);
  always_comb
    if(ReadMem) begin  //read memory
      DataOut = my_memory[DataAddress];
	  $display("Memory read M[%d] = %d",DataAddress,DataOut);
    end else //else output 0s
      DataOut = 16'bZ;

  always_ff @ (posedge CLK)
    if(WriteMem) begin  // write memory
      my_memory[DataAddress] = DataIn;
	  $display("Memory write M[%d] = %d",DataAddress,DataIn);
    end

endmodule
