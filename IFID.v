`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:12:59 11/23/2016 
// Design Name: 
// Module Name:    IFID 
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
module IFID(
    input clk,
	 input reset,
	 input IntReq,
	 input eret,
    input en,
    input [31:0] instr,
	 input [31:0] EPC,
    input [31:0] PC4,
	 input [31:0] PC8,
    output reg [31:0] instr_D,
    output reg [31:0] PC4_D,
	 output reg [31:0] PC8_D
    );
	 
	 initial begin
	     instr_D=0;
		  PC4_D=32'h0003000+3'b100;
		  PC8_D=32'h0003000+4'b1000;
	 end
	 
	 always@(posedge clk)begin
	     if(reset)begin
		      instr_D<=0;
				PC4_D<=32'h0003000+3'b100;
				PC8_D<=32'h0003000+4'b1000;
		  end
		  else if(IntReq)begin
		      instr_D<=0;
				PC4_D<=32'h0004180+3'b100;
				PC8_D<=32'h0004180+4'b1000;
		  end
		  else if(eret)begin
		      instr_D<=0;
				PC8_D<=EPC+4'b1000;
		  end
	     else if(en==1)begin
		      instr_D<=instr;
				PC4_D<=PC4;
				PC8_D<=PC8;
		  end
	 end


endmodule
