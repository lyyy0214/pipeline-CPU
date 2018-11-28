`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:05:36 11/13/2016 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input clk,
    input reset,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    input WE,
    output [31:0] R1,
    output [31:0] R2
    );
	 reg [31:0] register[31:0];
	 integer i;
	 
	 initial begin
	     for(i=0;i<32;i=i+1)
				    register[i]=32'b0;
		  end
	 
	 always@(posedge clk)begin
	     if(reset==1)begin
		      for(i=0;i<32;i=i+1)
				    register[i]<=0;
		  end
		  else begin
				if(WE==1&&A3!=0)begin
				    register[A3]<=WD;
					 $display("$%d <= %h",A3,WD);
				end
		  end
	 end
	 
	 assign R1=((A3==A1&A1!=0)&WE==1)?WD:register[A1];
	 assign R2=((A3==A2&A2!=0)&WE==1)?WD:register[A2];
	 


endmodule
