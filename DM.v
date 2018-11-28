`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:42:03 11/13/2016 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input clk,
    input reset,
	 input [31:0] IR_D,
	 input [31:0] IR_E,
    input [31:0] instr,//IR_M
	 input [31:0] IR_W,
	 input [31:0] PC_M,
	 input [7:2] HWInt,
    input [31:0] Add,
	 input [31:0] PrRD,
	 input ForwardRTM,
    input [31:0] ForwardB,
	 input [31:0] WD,
	 input [31:0] Data_E,
	 output MemW,
	 output IntReq,
	 output [31:0] EPC,
	 output [31:0] Datain,
    output [31:0] Dataout
    );
	 reg [31:0] mem[2047:0];
	 integer i=0;
	 
	 wire mtc0,mfc0;
	 wire[3:0] BE;
	 wire [31:0] DOut;
	 
	 controller controllerM(.op(instr[31:26]),.rs(instr[25:21]),.rt(instr[20:16]),.func(instr[5:0]),.MemW(MemW),.Mfc0(mfc0),.Mtc0(mtc0));
	 
	 assign Datain=(ForwardRTM==0)?ForwardB:WD;
	 
	 cp0 cp0(clk,reset,IR_D,IR_E,instr,IR_W,instr[20:16],instr[15:11],Datain,Data_E,PC_M,HWInt,IntReq,EPC,DOut);
	 
	 
	 
	 assign BE=(instr[31:26]==6'b101011)?4'b1111:  //sw
	           (instr[31:26]==6'b101000)?((Add[1:0]==2'b00)?4'b0001:(Add[1:0]==2'b01)?4'b0010:(Add[1:0]==2'b10)?4'b0100:4'b1000)://sb
				  (instr[31:26]==6'b101001)?((Add[1]==1)?4'b1100:4'b0011):0;  //sh 
	 
	 initial begin
	     for(i=0;i<2048;i=i+1)
				    mem[i]<=0;
	 end
	 
	 always@(posedge clk)begin
	     if(reset==1)
		      for(i=0;i<2038;i=i+1)
				    mem[i]<=0;
		  else begin
	         if(MemW==1&Add[31:13]==0&~IntReq)begin
				    if(instr[31:26]==6'b101011)begin  //sw
	                 mem[Add[12:2]]<=Datain;
					     $display("*%h <= %h",Add,Datain);
					 end
					 else if(instr[31:26]==6'b101000)begin  //sb
					     if(BE==4'b0001)begin
						      mem[Add[12:2]][7:0]<=Datain[7:0];
						  end
						  else if(BE==4'b0010)begin
						      mem[Add[12:2]][15:8]<=Datain[7:0];
						  end
						  else if(BE==4'b0100)begin
						      mem[Add[12:2]][23:16]<=Datain[7:0];
						  end
						  else begin
						      mem[Add[12:2]][31:24]<=Datain[7:0];
						  end
						  $display("*%h <= %h",Add,Datain[7:0]);
					 end
					 else if(instr[31:26]==6'b101001) begin
					     if(BE==4'b1100)begin
						      mem[Add[12:2]][31:16]<=Datain[15:0];
						  end
						  else begin
						      mem[Add[12:2]][15:0]<=Datain[15:0];
						  end
						  $display("*%h <= %h",Add,Datain[15:0]);
					 end
		      end
	  	 end
	 end
	 
	 assign Dataout=mfc0?DOut:(Add>32'h00003000)?PrRD:mem[Add[11:2]];


endmodule
