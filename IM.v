`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:30:41 11/13/2016 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input [31:0] Add,
    output reg [31:0] Data
    );
	 reg [31:0] im[2047:0];
	 
	 initial begin
	     $readmemh("code.txt",im);
		  $readmemh("handler.txt",im,1120,1800);
	 end
	 
	 always @(Add)begin
	     Data<=im[Add[12:2]];
	 end
	 
endmodule
