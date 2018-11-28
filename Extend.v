`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:43:04 11/14/2016 
// Design Name: 
// Module Name:    Extend 
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
module Extend(
    input Extend,
    input [15:0] in,
    output reg [31:0] out
    );
	 integer i;
	 
	 always @* begin
	 if(Extend==1'b0)begin
	     for(i=16;i<32;i=i+1)
		      out[i]<=0;
	 out[15:0]<=in;
	 end
	 else begin
	     if(in[15]==0)begin
		      for(i=16;i<32;i=i+1)
				    out[i]<=0;
		  end
		  else begin
		      for(i=16;i<32;i=i+1)
				    out[i]<=1;
		  end
		  
    out[15:0]<=in;
	 end
	 end

endmodule
