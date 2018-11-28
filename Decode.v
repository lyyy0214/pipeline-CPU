`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:34:43 11/23/2016 
// Design Name: 
// Module Name:    Decode 
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
module Decode(
    input clk,
	 input reset,
    input [31:0] instr,
    input [31:0] PC4,
	 input [31:0] PC8,
	 input [4:0] A3,
	 input [1:0] ForwardRSD,
	 input [1:0] ForwardRTD,
	 input [31:0] AO,
	 input [31:0] WD,
	 input [31:0] PC_8,
	 input WE,
    output [31:0] D1,
    output [31:0] D2,
    output [31:0] Ext,
	 output Branch,
	 output [1:0] Jump,
	 output eret,
	 output [31:0] PC_Beq,
	 output [31:0] PC_J,
	 output [31:0] PC_Jr,
	 output RegW
    );
	 
	 wire ExtendS,Equal,More,Less,we,BRegW;
	 wire [1:0] Jump;
	 wire [3:0] BOp;
	 wire [31:0] PC,RSD,RTD;
	 
	 controller controllerD(.op(instr[31:26]),.rs(instr[25:21]),.rt(instr[20:16]),.func(instr[5:0]),.Extend(ExtendS),.Eret(eret),.Jump(Jump),.BOp(BOp),.RegW(we));
	 
	 GRF GRF(clk,reset,instr[25:21],instr[20:16],A3,WD,WE,RSD,RTD);
	 
	 Extend ExtendD(ExtendS,instr[15:0],Ext);
	 
	 assign D1=(ForwardRSD==2'b00)?RSD:(ForwardRSD==2'b01)?AO:(ForwardRSD==2'b11)?PC_8:WD;
	 assign D2=(ForwardRTD==2'b00)?RTD:(ForwardRTD==2'b01)?AO:(ForwardRTD==2'b11)?PC_8:WD;
	 
	 CMP CMP(D1,D2,BOp,More,Equal,Less);
	 
	 assign Branch=(BOp==4'b0001 & Equal==1)|(BOp==4'b0010 & Equal==0)|(BOp==4'b0011&(More|Equal))|
	               (BOp==4'b0100 & (Equal|Less))|(BOp==4'b0101 & Less)|(BOp==4'b0110 &(More|Equal))|
						(BOp==4'b0111 & More);
	 
	 assign BRegW=(BOp==4'b0011)&(More|Equal);
	 assign RegW=we|BRegW;  //bgezal满足条件时 写使能为1
	 
	 assign PC=PC4-3'b100;
	 
	 assign PC_Beq={Ext[29:0],1'b0,1'b0}+PC4;
	 assign PC_J={PC[31:28],instr[25:0],1'b0,1'b0};
	 assign PC_Jr=D1;
	 
	 


endmodule
