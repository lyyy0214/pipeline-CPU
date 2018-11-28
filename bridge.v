`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:25:49 12/19/2016 
// Design Name: 
// Module Name:    bridge 
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
module bridge(
    input PrWE,
	 input [31:0] PrAddr,
    input [31:0] DEV0_RD,
	 input [31:0] DEV1_RD,
	 input [31:0] Pr_WD,
	 output DEV0_WE,
	 output DEV1_WE,
    output [31:0] DEV_Addr,
	 output [31:0] PrRD,
    output [31:0] DEV_WD
    );
	 
	 assign DEV_WD=Pr_WD;
	 assign DEV_Addr=PrAddr;
	 assign PrRD=(PrAddr[15:4]==12'h7F0)?DEV0_RD:(PrAddr[15:4]==12'h7F1)?DEV1_RD:0;
	 assign DEV0_WE=(PrAddr[15:4]==12'h7F0)&PrWE;
	 assign DEV1_WE=(PrAddr[15:4]==12'h7F1)&PrWE;


endmodule
