`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:01:22 12/12/2016 
// Design Name: 
// Module Name:    ALUX 
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
module ALUX(
    input clk,
	 input reset,
	 input start,
	 input signed [31:0] A,
    input signed [31:0] B,
    input [3:0] Op,
	 output reg busy,
    output reg [31:0] HI,
    output reg [31:0] LO
    );
	 
	 reg [3:0] count;
	 reg [31:0] hi,lo;
	 
	 wire [63:0] C,result;
	 
	 assign C={HI,32'b0}|{32'b0,LO};
	 assign result=$signed(A)*$signed(B)+$signed(C);
	 
	 initial begin
	     hi=32'b0;
	     lo=32'b0;
		  HI=32'b0;
		  LO=32'b0;;
		  busy=0;
		  count=1'b1;
	 end
	 
	 always@(posedge clk)begin
	     if(reset)begin
		       hi<=32'b0;
	          lo<=32'b0;
				 HI<=32'b0;
		       LO<=32'b0;;
		       busy<=0;
				 count<=1'b1;
		  end
		  else if(start&(~busy))begin
		      case(Op)
				    4'b0000: begin {hi,lo}<=$signed(A)*$signed(B); //mult
					                count<=4'b0011;
										 busy<=1'b1;
										 end
					 4'b0001: begin {hi,lo}<={1'b0,A}*{1'b0,B}; //multu
					                count<=4'b0011;
										 busy<=1'b1;
										 end
					 4'b0010: begin  if(B!=0)begin
					                    lo<=$signed(A)/$signed(B);//div
					                    hi<=$signed(A)%$signed(B);
					                    count<=4'b1000;
										     busy<=1'b1;
											  end
										 end
					 4'b0011: begin  if(B!=0)begin
					                    lo<={1'b0,A}/{1'b0,B};//divu
					                    hi<={1'b0,A}%{1'b0,B};
										     count<=4'b1000;
										     busy<=1'b1;
											  end
										 end
					 4'b1000: begin hi<=result[63:32]; //madd
					                lo<=result[31:0];
										 count<=4'b0011;
										 busy<=1'b1;
										 end
				endcase
		  end
		  if(busy)begin
		      count<=count-1'b1;
			   end
		  if(count==0)begin
		      HI<=hi;
				LO<=lo;
				busy<=0;
				end
		  if(Op==4'b0100)begin//mthi
		      HI<=A;
				end
		  else if (Op==4'b0101)begin//mtlo
		      LO<=A;
				end
	 end
	 


endmodule
