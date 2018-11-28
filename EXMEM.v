`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:36:02 11/23/2016 
// Design Name: 
// Module Name:    EXMEM 
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
module EXMEM(
    input clk,
    input reset,
    input [31:0] instr_E,
    input [31:0] PC4_E,
    input [31:0] PC8_E,
    input [31:0] AO_E,
	 input [31:0] MEMD,
	 input RegW_E,
    output reg [31:0] instr_M,
    output reg [31:0] PC4_M,
    output reg [31:0] PC8_M,
    output reg [31:0] AO_M,
    output reg [31:0] MEMD_M,
	 output reg RegW_M
    );
	 
	 initial begin
	     instr_M=0;
		  PC4_M=0;
		  PC8_M=0;
		  AO_M=0;
		  MEMD_M=0;
		  RegW_M=0;
	 end
	 
	 always@(posedge clk)begin
	     if(reset==1)begin
		      instr_M<=0;
				PC4_M<=0;
				PC8_M<=0;
				AO_M<=0;
				MEMD_M<=0;
				RegW_M<=0;
		  end
		  else begin
		      instr_M<=instr_E;
				PC4_M<=PC4_E;
				PC8_M<=PC8_E;
				AO_M<=AO_E;
				MEMD_M<=MEMD;
				RegW_M<=RegW_E;
		  end
	 end



endmodule
