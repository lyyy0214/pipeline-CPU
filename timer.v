`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:00:16 12/20/2016 
// Design Name: 
// Module Name:    timer 
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
module timer(
    input clk,
    input reset,
	 input WE,
    input [31:0] ADD_I,
    input [31:0] DAT_I,
    output [31:0] DAT_O,
    output IRQ
    );
	 
	 reg [31:0] ctrl,preset,count;
	 reg CE,CI;
	 
	 initial begin
	     ctrl=0;
		  preset=0;
		  count=0;
		  CE=0;
		  CI=0;
	 end
	 
	 always@(posedge clk)begin
	      if(reset)begin
			    ctrl<=0;
				 preset<=0;
				 count<=0;
				 CE<=0;
				 CI<=0;
			end
			else if(WE)begin
			    if(ADD_I[3:0]==0)
				     ctrl<=DAT_I;
				 else if(ADD_I[3:0]==4'b0100)
				     preset<=DAT_I;
			end
			
			if(ctrl[0]==0) begin  //idle
				 count<=0;
				 CE<=0;
			end
			else if(ctrl[0]==1&CE==0)begin  //load
			    count<=preset;
				 CE<=1'b1;
				 CI<=preset?0:1'b1;
			end
			else if(ctrl[0]==1&CE==1'b1)begin
			    if(count!=1&count!=0)begin  //count
				     count<=count-1'b1;
					  CI<=0;
				 end
				 else if(count==1)begin
					  count<=0;
					  CI<=1'b1;
				 end
				 else if(count==0)begin
				     if(ctrl[2:1]==2'b01)begin  //mode1:count=preset mode0:count=0
					      count<=preset;
							CI<=0;
					  end
				     if(ctrl[2:1]==2'b00)begin//mode0
					      ctrl[0]<=0;
							CE<=0;
					  end
				 end
			end
			
	 
	 end
    assign IRQ=CI&ctrl[3]&~((ADD_I[3:0]==0)&WE&DAT_I[3]==1'b0)&~((ADD_I[3:0]==0)&WE&DAT_I[0]==1'b1);//eret的上一条sw是对ctrl做处理
	 assign DAT_O=(ADD_I[3:2]==2'b00)?ctrl:(ADD_I[3:2]==2'b01)?preset:count;

endmodule
