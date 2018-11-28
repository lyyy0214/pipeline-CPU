`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:32:44 11/23/2016 
// Design Name: 
// Module Name:    Excution 
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
module Excution(
    input clk,
	 input reset,
    input [31:0] instr,
    input [31:0] D1,
    input [31:0] D2,
    input [31:0] Ext,
	 input [1:0] ForwardRSE,
	 input [1:0] ForwardRTE,
	 input [31:0] AO_M,
	 input [31:0] WD,
	 input [31:0] PC_8,
	 input RegW_EX,
	 output RegW,
	 output busy,
    output [31:0] ALUOut,
    output [31:0] DMData
    );
	 
	 wire AluSB,AluSA,ALURegW,md;
	 wire [3:0] ALUXOp;
	 wire [4:0] ALUOp;
	 wire [31:0] A,B,ForwardA,ForwardB,HI,LO,aluout;
	 
	 controller controllerE(.op(instr[31:26]),.rs(instr[25:21]),.rt(instr[20:16]),.func(instr[5:0]),.AluSA(AluSA),.AluSB(AluSB),
	                        .ALUOp(ALUOp),.ALUXOp(ALUXOp),.md(md));
	 
	 assign ForwardA=(ForwardRSE==2'b0)?D1:(ForwardRSE==2'b01)?AO_M:(ForwardRSE==2'b11)?PC_8:WD;
	 assign ForwardB=(ForwardRTE==2'b0)?D2:(ForwardRTE==2'b01)?AO_M:(ForwardRTE==2'b11)?PC_8:WD;
	 assign DMData=ForwardB;
	 
	 assign B=AluSB?Ext:ForwardB;
	 assign A=AluSA?instr[10:6]:ForwardA;
	 
	 ALU ALUE(A,B,ALUOp,ALURegW,aluout);
	 ALUX ALUX(clk,reset,md,A,B,ALUXOp,busy,HI,LO);
	 assign ALUOut=(ALUXOp==4'b0110)?HI:(ALUXOp==4'b0111)?LO:aluout;   //110-mfhi 111-mflo
	 assign RegW=ALURegW|RegW_EX;  //movz满足条件时，ALURegW为1


endmodule
