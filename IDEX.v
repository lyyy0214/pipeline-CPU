`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:05:27 11/23/2016 
// Design Name: 
// Module Name:    IDEX 
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
module IDEX(
    input clk,
    input reset,
    input clr,
    input [31:0] instr_D,
    input [31:0] PC4_D,
    input [31:0] PC8_D,
    input [31:0] RS_D,
    input [31:0] RT_D,
    input [31:0] EXT_D,
	 input RegW_D,
    output reg [31:0] instr_E,
    output reg [31:0] PC4_E,
    output reg [31:0] PC8_E,
    output reg [31:0] RS_E,
    output reg [31:0] RT_E,
    output reg [31:0] EXT_E,
	 output reg RegW_EX
    );
	 
	 initial begin
	     instr_E=0;
		  PC4_E=0;
		  PC8_E=0;
		  RS_E=0;
		  RT_E=0;
		  EXT_E=0;
		  RegW_EX=0;
	 end
	 
	 always@(posedge clk)begin
	     if(reset==1)begin
		    instr_E<=0;
				PC4_E<=0;
				PC8_E<=0;
				RS_E<=0;
				RT_E<=0;
				EXT_E<=0;
				RegW_EX=0;
		  end
		  else if(clr==1)begin
		      instr_E<=0;
				PC4_E<=PC4_D;
				PC8_E<=0;
				RS_E<=0;
				RT_E<=0;
				EXT_E<=0;
				RegW_EX=0;
		  end
		  else begin
		      instr_E<=instr_D;
				PC4_E<=PC4_D;
				PC8_E<=PC8_D;
				RS_E<=RS_D;
				RT_E<=RT_D;
				EXT_E<=EXT_D;
				RegW_EX=RegW_D;
		  end
	 end


endmodule
