`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:51:05 11/23/2016 
// Design Name: 
// Module Name:    Write 
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
module Write(
    input [31:0] instr,
    input [31:0] AO,
    input [31:0] DR,
    input [31:0] PC8,
	 output [4:0] A3,
    output [31:0] RegWD
    );
	 
	 wire [1:0] RegD,MTR;
	 wire [31:0] DM;
	 wire [2:0] LOp;   //000-lw 001-lb 010-lbu 011-lh 100-lhu
	 
	 controller controllerW(.op(instr[31:26]),.rs(instr[25:21]),.rt(instr[20:16]),.func(instr[5:0]),.RegD(RegD),.MTR(MTR),.LOp(LOp));
	 
	 assign DM=(LOp==0)?DR:
	           (LOp==3'b001)?((AO[1:0]==0)?({{24{DR[7]}},DR[7:0]}):(AO[1:0]==2'b01)?({{24{DR[15]}},DR[15:8]}):
				                 (AO[1:0]==2'b10)?({{24{DR[23]}},DR[23:16]}):({{24{DR[31]}},DR[31:24]})):
				  (LOp==3'b010)?((AO[1:0]==0)?$unsigned(DR[7:0]):(AO[1:0]==2'b01)?$unsigned(DR[15:8]):
				                 (AO[1:0]==2'b10)?$unsigned(DR[23:16]):$unsigned(DR[31:24])):
				  (LOp==3'b011)?((AO[1]==0)?({{16{DR[15]}},DR[15:0]}):({{16{DR[31]}},DR[31:16]})):
				  (LOp==3'b100)?((AO[1]==0)?$unsigned(DR[15:0]):$unsigned(DR[31:16])):0;
	 
	 assign RegWD=(MTR==2'b00)?AO:(MTR==2'b01)?DM:PC8;
	 
	 assign A3=(RegD==2'b00)?instr[20:16]:(RegD==2'b01)?instr[15:11]:5'b11111;


endmodule
