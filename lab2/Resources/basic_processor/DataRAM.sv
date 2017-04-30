//////////////////////////////////////////////////////////////////////////////////
// Engineer:
//
// Create Date:    19:25:24 11/16/2006
// Design Name:
// Module Name:    DataRAM
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
module DataRAM(DataAddress, ReadMem, WriteMem, DataIn, DataOut, CLK);
    input CLK;

    input [15:0] DataAddress;
    input ReadMem;
    input WriteMem;
    input [15:0] DataIn;

    output [15:0] DataOut;
    logic [15:0] DataOut;

    logic [15:0] my_memory [0:255];

    initial
        $readmemh("dataram_init.list", my_memory);

    always_comb
        if(ReadMem) begin
            DataOut = my_memory[DataAddress];
            $display("Memory read M[%d] = %d",DataAddress,DataOut);
        end else
            DataOut = 16'bZ;

    always @ (posedge CLK)
        if(WriteMem) begin
            my_memory[DataAddress] = DataIn;
            $display("Memory write M[%d] = %d",DataAddress,DataIn);
        end

endmodule
