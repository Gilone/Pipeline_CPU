`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:43:26 05/16/2019 
// Design Name: 
// Module Name:    WB_STAGE 
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
module write_back(C_ALU,MEM_OUT,m2reg,wdi
    );
	 input [31:0] C_ALU;
	 input [31:0] MEM_OUT;
	 input m2reg;
	 output [31:0] wdi;
	 
	 mux32_2_1 wb_stage (C_ALU, MEM_OUT, m2reg, wdi);

endmodule
