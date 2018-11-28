`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:51:51 11/23/2016 
// Design Name: 
// Module Name:    MEMWB 
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
module MEMWB(
    input clk,
    input reset,
    input [31:0] instr_M,
    input [31:0] PC4_M,
    input [31:0] PC8_M,
    input [31:0] AO_M,
    input [31:0] DR_M,
	 input RegW_M,
    output reg [31:0] instr_W,
    output reg [31:0] PC4_W,
    output reg [31:0] PC8_W,
    output reg [31:0] AO_W,
    output reg [31:0] DR_W,
	 output reg RegW_W
    );
	 
	 initial begin
	     instr_W=0;
		  PC4_W=0;
		  PC8_W=0;
		  AO_W=0;
		  DR_W=0;
		  RegW_W=0;
	 end
	 
	 always@(posedge clk)begin
	     if(reset==1)begin
		      instr_W<=0;
				PC4_W<=0;
				PC8_W<=0;
				AO_W<=0;
				DR_W<=0;
				RegW_W<=0;
		  end
		  else begin
		      instr_W<=instr_M;
				PC4_W<=PC4_M;
				PC8_W<=PC8_M;
				AO_W<=AO_M;
				DR_W<=DR_M;
				RegW_W<=RegW_M;
		  end
	 end


endmodule
