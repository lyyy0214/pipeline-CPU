`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:00:47 11/13/2016 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
    input clk,
    input reset,
	 input PCEn,
	 input Branch,
	 input [1:0] Jump,
	 input IntReq,
	 input eret,
	 input [31:0] EPC,
	 input [31:0] PC_Beq,
	 input [31:0] PC_J,
	 input [31:0] PC_Jr,
    output [31:0] instr,
	 output [31:0] PC4,
	 output [31:0] PC8
    );
	 
	 reg [31:0] PC;
	 wire [31:0] nPC;
	 reg EHOK;
	 	 	 
	 IM IM(PC-32'h00003000,instr);
	 
	 initial begin
	     PC=32'h00003000;
		  EHOK=0;
	 end
	 
	 assign PC4=PC+3'b100;
	 assign PC8=PC+4'b1000;
	 
	 always@(posedge clk)begin
	     if(reset==1)begin
		      PC<=32'h00003000;
				EHOK<=0;
		  end
		  else if(PCEn==1)
	         PC<=nPC;
		  if(IntReq&~EHOK)
		      EHOK<=1'b1;
		  else if(eret)
		      EHOK<=0;
	 end
	 
	 assign nPC=(IntReq&~EHOK)?32'h00004180:eret?EPC:(Jump==2'b01&Branch==1)?PC_Beq:(Jump==2'b10)?PC_J:(Jump==2'b11)?PC_Jr:PC4;
	 
endmodule
