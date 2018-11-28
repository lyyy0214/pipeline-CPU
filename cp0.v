`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:40:44 12/20/2016 
// Design Name: 
// Module Name:    cp0 
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
module cp0(
    input clk,
	 input reset,
	 input [31:0] IR_D,
	 input [31:0] IR_E,
	 input [31:0] IR_M,
	 input [31:0] IR_W,
	 input [4:0] A1,
    input [4:0] A2,
    input [31:0] DIn,
	 input [31:0] Data_E,
    input [31:0] PC,
    input [5:0] HWInt,
    output IntReq,//中断请求 输出至cpu
    output [31:0] EPC,
    output [31:0] DOut
    );
	 
	 reg [31:0] cp0register[15:12];   //12-SR 13-CAUSE 14-EPC 15 PrlD
	 
	 wire eret_D;
	 wire mtc0_E;
	 wire md_M,mt_M,mf_M,mtc0_M,eret_M;
	 wire b_W,j_W,jal_W,jalr_W,jr_W;
	 
	 controller con_cp0_D(.op(IR_D[31:26]),.rs(IR_D[25:21]),.rt(IR_D[20:16]),.func(IR_D[5:0]),.Eret(eret_D));
	 controller con_cp0_E(.op(IR_E[31:26]),.rs(IR_E[25:21]),.rt(IR_E[20:16]),.func(IR_E[5:0]),.Mtc0(mtc0_E));
	 controller con_cp0_M(.op(IR_M[31:26]),.rs(IR_M[25:21]),.rt(IR_M[20:16]),.func(IR_M[5:0]),.Eret(eret_M),.Mtc0(mtc0_M),.md(md_M),.mt(mt_M),.mf(mf_M));
	 controller con_cp0_W(.op(IR_W[31:26]),.rs(IR_W[25:21]),.rt(IR_W[20:16]),.func(IR_W[5:0]),.B(b_W),.J(j_W),.JAL(jal_W),.JALR(jalr_W),.JR(jr_W));
	 
	 
	 initial begin
	     cp0register[15]=0;
		  cp0register[14]=0;
		  cp0register[13]=0;
		  cp0register[12]=0;
	 end
	 
	 always@(posedge clk)begin
	     if(reset)begin
		      cp0register[15]<=0;
				cp0register[14]<=0;
				cp0register[13]<=0;
				cp0register[12]<=0;
		  end
		  else begin
		      cp0register[13][15:10]<=HWInt;  //cause
		  end
		  
		  if(IntReq)begin
		      cp0register[12][1]<=1'b1;
				if(b_W|j_W|jal_W|jalr_W|jr_W)begin
				    cp0register[14]<=PC-32'h4;
				end
				else if(md_M|mf_M|mt_M)begin
				    cp0register[14]<=PC+32'h4;
				end
				else if(PC<=32'h00004180)
				    cp0register[14]<=PC;
		  end
		  else if(eret_M)begin//M级置位
		      cp0register[12][1]<=1'b0;
				
		  end
		  else if(mtc0_M)begin
		      if(A2==5'b01100)
				    cp0register[12]<=DIn;
				else if(A2==5'b01110)
				    cp0register[14]<=DIn;
		  end
	 end
	 
	 assign DOut=(A2[3:2]==2'b11)?cp0register[A2]:0;
	 assign EPC=cp0register[14];
	 assign IntReq=(HWInt[0]&cp0register[12][10]|HWInt[1]&cp0register[12][11])&cp0register[12][0]&~cp0register[12][1];

endmodule
