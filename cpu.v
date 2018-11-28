`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:27:14 11/15/2016 
// Design Name: 
// Module Name:    top 
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
module cpu(
    input clk,
    input reset,
	 input [31:0] PrRD,//从bridge读入的数据
	 input [7:2] HWInt,//6个设备的中断请求
	 output [31:0] PrAddr,//32位地址总线
	 output [31:0] PrWD,//32位输入至bridge的数据
	 output PrWE
    );
	 
	 wire en,clr,stop,WE,Branch,busy,MemW,IntReq,LineReset,eret;
	 wire [31:0] IR,PC4,PC8,IR_D,PC4_D,PC8_D,IR_E,PC4_E,PC8_E,IR_M,PC4_M,PC8_M,IR_W,PC4_W,PC8_W,EPC;
	 wire [31:0] D1,D2,Ext,D1_E,D2_E,Ext_E,PC_Beq,PC_J,PC_Jr;
	 wire [31:0] AO,MEMD,AO_M,DR,AO_W,DR_W,WD,MEMD_M,SWData;
	 wire [1:0] ForwardRSD,ForwardRTD,ForwardRSE,ForwardRTE,Jump;
	 wire [4:0] A3;
	 wire ForwardRTM;
	 wire RegW_D,RegW_EX,RegW_E,RegW_M,RegW_W;
	 
	 IFU IFU(clk,reset,en|IntReq,Branch,Jump,IntReq,eret,EPC,PC_Beq,PC_J,PC_Jr,IR,PC4,PC8);
	 
	 IFID IFID(clk,reset,IntReq,eret,en|IntReq,IR,EPC,PC4,PC8,IR_D,PC4_D,PC8_D);
	 
	 Decode Decode(clk,reset,IR_D,PC4_D,PC8_D,A3,ForwardRSD,ForwardRTD,AO_M,WD,PC8_M,RegW_W,
	               D1,D2,Ext,Branch,Jump,eret,PC_Beq,PC_J,PC_Jr,RegW_D);
	 
	 IDEX IDEX(clk,LineReset,clr&~IntReq,IR_D,PC4_D,PC8_D,D1,D2,Ext,RegW_D,IR_E,PC4_E,PC8_E,D1_E,D2_E,Ext_E,RegW_EX);
	 
	 Excution Excution(clk,reset,IR_E,D1_E,D2_E,Ext_E,ForwardRSE,ForwardRTE,AO_M,WD,PC8_M,RegW_EX,
	                   RegW_E,busy,AO,MEMD);
	 
	 EXMEM EXMEM(clk,LineReset,IR_E,PC4_E,PC8_E,AO,MEMD,RegW_E,IR_M,PC4_M,PC8_M,AO_M,MEMD_M,RegW_M);
	 
	 DM DM(clk,reset,IR_D,IR_E,IR_M,IR_M,PC4_M-32'h4,HWInt,AO_M,PrRD,ForwardRTM,MEMD_M,WD,MEMD,MemW,IntReq,EPC,SWData,DR);
	                                                      //addr         Drt_M  forward Drt_E
	 assign PrAddr=AO_M;
	 assign PrWD=SWData;
	 assign PrWE=MemW;
	 assign LineReset=reset&IntReq;
	 
	 
	 MEMWB MEMWB(clk,LineReset,IR_M,PC4_M,PC8_M,AO_M,DR,RegW_M,IR_W,PC4_W,PC8_W,AO_W,DR_W,RegW_W);
	 
	 Write Write(IR_W,AO_W,DR_W,PC8_W,A3,WD);
	 
	 stall stall(busy,IR_D,IR_E,IR_M,en,clr);
	 //中断时产生的暂停信号要取消
	 
	 
	 //forward---------------------------------------------------------------------------------------------
	 
	 wire cal_i_D,cal_r_D,jal_D,jalr_D,beq_D,ld_D,st_D,jr_D;
	 wire cal_i_E,cal_r_E,jal_E,jalr_E,beq_E,ld_E,st_E,jr_E,mtc0_E;
	 wire cal_i_M,cal_r_M,jal_M,jalr_M,beq_M,ld_M,st_M,jr_M,mtc0_M;
	 wire cal_i_W,cal_r_W,jal_W,jalr_W,beq_W,ld_W,st_W,jr_W;
	 
	 `define rs 25:21
	 `define rt 20:16
	 `define rd 15:11
	 
	 controller controllerD(.op(IR_D[31:26]),.rs(IR_D[25:21]),.rt(IR_D[20:16]),.func(IR_D[5:0]),.ld(ld_D),.st(st_D),.B(beq_D),.cal_i(cal_i_D),.cal_r(cal_r_D),.JAL(jal_D),.JALR(jalr_D),.JR(jr_D));
	 controller controllerE(.op(IR_E[31:26]),.rs(IR_E[25:21]),.rt(IR_E[20:16]),.func(IR_E[5:0]),.ld(ld_E),.st(st_E),.B(beq_E),.cal_i(cal_i_E),.cal_r(cal_r_E),.JAL(jal_E),.JALR(jalr_E),.JR(jr_E),.Mtc0(mtc0_E));
	 controller controllerM(.op(IR_M[31:26]),.rs(IR_M[25:21]),.rt(IR_M[20:16]),.func(IR_M[5:0]),.ld(ld_M),.st(st_M),.B(beq_M),.cal_i(cal_i_M),.cal_r(cal_r_M),.JAL(jal_M),.JALR(jalr_M),.JR(jr_M),.Mtc0(mtc0_M));
	 controller controllerW(.op(IR_W[31:26]),.rs(IR_W[25:21]),.rt(IR_W[20:16]),.func(IR_W[5:0]),.ld(ld_W),.st(st_W),.B(beq_W),.cal_i(cal_i_W),.cal_r(cal_r_W),.JAL(jal_W),.JALR(jalr_W),.JR(jr_W));
	 
	 
	 assign ForwardRSD=(beq_D|jalr_D|jr_D)&cal_r_M&(IR_D[`rs]==IR_M[`rd])&(IR_D[`rs]!=0)&RegW_M?1:
	                   (beq_D|jalr_D|jr_D)&cal_i_M&(IR_D[`rs]==IR_M[`rt])&(IR_D[`rs]!=0)?1:
							 (beq_D|jalr_D|jr_D)&jal_M&(IR_D[`rs]==5'b11111)&RegW_M?3:
							 (beq_D|jalr_D|jr_D)&jalr_M&(IR_D[`rs]==IR_M[`rd])&(IR_D[`rs]!=0)?3:
							 (beq_D|jalr_D|jr_D)&(cal_r_W|jalr_W)&(IR_D[`rs]==IR_W[`rd])&(IR_D[`rs]!=0)&RegW_W?2:
							 (beq_D|jalr_D|jr_D)&(cal_i_W|ld_W)&(IR_D[`rs]==IR_W[`rt])&(IR_D[`rs]!=0)?2:
							 (beq_D|jalr_D|jr_D)&jal_W&(IR_D[`rs]==5'b11111)&RegW_W?2:0;  //0:寄存器输出 1：ALU输出 2：写入 3：PC+8
	 
	 assign ForwardRTD=beq_D&cal_r_M&(IR_D[`rt]==IR_M[`rd])&(IR_D[`rt]!=0)&RegW_M?1:
	                   beq_D&cal_i_M&(IR_D[`rt]==IR_M[`rt])&(IR_D[`rt]!=0)?1:
							 beq_D&jal_M&(IR_D[`rt]==5'b11111)&RegW_M?3:
							 beq_D&jalr_M&(IR_D[`rt]==IR_M[`rd])&(IR_D[`rt]!=0)?3:
							 beq_D&(cal_r_W|jalr_W)&(IR_D[`rt]==IR_W[`rd])&(IR_D[`rt]!=0)&RegW_W?2:
							 beq_D&(cal_i_W|ld_W)&(IR_D[`rt]==IR_W[`rt])&(IR_D[`rt]!=0)?2:
							 beq_D&jal_W&(IR_D[`rt]==5'b11111)&RegW_W?2:0;  //0:寄存器输出 1：ALU输出 2：写入 3：PC+8
	 
	 assign ForwardRSE=(cal_i_E|cal_r_E|ld_E|st_E)&cal_r_M&(IR_E[`rs]==IR_M[`rd])&(IR_E[`rs]!=0)&RegW_M?1:
	                   (cal_i_E|cal_r_E|ld_E|st_E)&cal_i_M&(IR_E[`rs]==IR_M[`rt])&(IR_E[`rs]!=0)?1:
							 (cal_i_E|cal_r_E|ld_E|st_E)&jal_M&(IR_E[`rs]==5'b11111)&RegW_M?3:
							 (cal_i_E|cal_r_E|ld_E|st_E)&jalr_M&(IR_E[`rs]==IR_M[`rd])&(IR_E[`rs]!=0)?3:
							 (cal_i_E|cal_r_E|ld_E|st_E)&(cal_r_W|jalr_W)&(IR_E[`rs]==IR_W[`rd])&(IR_E[`rs]!=0)&RegW_W?2:
							 (cal_i_E|cal_r_E|ld_E|st_E)&(cal_i_W|ld_W)&(IR_E[`rs]==IR_W[`rt])&(IR_E[`rs]!=0)?2:
							 (cal_i_E|cal_r_E|ld_E|st_E)&jal_W&(IR_E[`rs]==5'b11111)&RegW_W?2:0;//0:寄存器输出 1：ALU输出 2：写入 3：PC+8
	 
	 assign ForwardRTE=(cal_r_E|st_E|mtc0_E)&cal_r_M&(IR_E[`rt]==IR_M[`rd])&(IR_E[`rt]!=0)&RegW_M?1:
	                   (cal_r_E|st_E|mtc0_E)&cal_i_M&(IR_E[`rt]==IR_M[`rt])&(IR_E[`rt]!=0)?1:
							 (cal_r_E|st_E|mtc0_E)&jal_M&(IR_E[`rt]==5'b11111)&RegW_M?3:
                      (cal_r_E|st_E|mtc0_E)&jalr_M&(IR_E[`rt]==IR_M[`rd])&(IR_E[`rt]!=0)?3:
							 (cal_r_E|st_E|mtc0_E)&(cal_r_W|jalr_W)&(IR_E[`rt]==IR_W[`rd])&(IR_E[`rt]!=0)&RegW_W?2:
							 (cal_r_E|st_E|mtc0_E)&(cal_i_W|ld_W)&(IR_E[`rt]==IR_W[`rt])&(IR_E[`rt]!=0)?2:
							 (cal_r_E|st_E|mtc0_E)&jal_W&(IR_E[`rt]==5'b11111)&RegW_W?2:0;//0:寄存器输出 1：ALU输出 2：写入 3：PC+8
	 
	 assign ForwardRTM=(st_M|mtc0_M)&(cal_r_W|jalr_W)&(IR_M[`rt]==IR_W[`rd])&(IR_M[`rt]!=0)&RegW_W?1:
	                   (st_M|mtc0_M)&(cal_i_W|ld_W)&(IR_M[`rt]==IR_W[`rt])&(IR_M[`rt]!=0)?1:
							 (st_M|mtc0_M)&jal_W&(IR_M[`rt]==5'b11111)&RegW_W?1:0;   //1：Reg写入
	 

endmodule

