`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:25:06 11/23/2016 
// Design Name: 
// Module Name:    stall 
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
module stall(
	 input busy,
	 input [31:0] IR_D,
    input [31:0] IR_E,
    input [31:0] IR_M,
    output en,
    output clr
    );
	 
	 wire stall_beq,stall_cal_r,stall_cal_i,stall_ld,stall_st,stall_jr,stall_jalr,stall_md,stall;
	 wire cal_i_D,cal_r_D,jr_D,jalr_D,beq_D,ld_D,st_D,md_D,mt_D,mf_D;
	 wire cal_i_E,cal_r_E,jr_E,jalr_E,beq_E,ld_E,st_E,md_E;
	 wire cal_i_M,cal_r_M,jr_M,jalr_M,beq_M,ld_M,st_M;
	 wire [3:0] BOp;
	 
	 `define rs 25:21
	 `define rt 20:16
	 `define rd 15:11
	 
	 controller controllerD(.op(IR_D[31:26]),.rs(IR_D[25:21]),.rt(IR_D[20:16]),.func(IR_D[5:0]),
	 .BOp(BOp),.ld(ld_D),.st(st_D),.md(md_D),.mf(mf_D),.mt(mt_D),.B(beq_D),.cal_i(cal_i_D),.cal_r(cal_r_D),.JR(jr_D),.JALR(jalr_D));
	 
	 controller controllerE(.op(IR_E[31:26]),.rs(IR_E[25:21]),.rt(IR_E[20:16]),.func(IR_E[5:0]),
	 .ld(ld_E),.st(st_E),.B(beq_E),.md(md_E),.cal_i(cal_i_E),.cal_r(cal_r_E),.JR(jr_E),.JALR(jalr_E));
	 
	 controller controllerM(.op(IR_M[31:26]),.rs(IR_M[25:21]),.rt(IR_M[20:16]),.func(IR_M[5:0]),
	 .ld(ld_M),.st(st_M),.B(beq_M),.cal_i(cal_i_M),.cal_r(cal_r_M),.JR(jr_M),.JALR(jalr_M));
	 
	 assign stall_beq=(beq_D&cal_r_E&(((IR_D[`rs]==IR_E[`rd])&IR_D[`rs]!=0)|(BOp!=4'b0011&(IR_D[`rt]==IR_E[`rd])&IR_D[`rt]!=0)))|
	                  (beq_D&cal_i_E&(((IR_D[`rs]==IR_E[`rt])&IR_D[`rs]!=0)|(BOp!=4'b0011&(IR_D[`rt]==IR_E[`rt])&IR_D[`rt]!=0)))|
							(beq_D&ld_E&(((IR_D[`rs]==IR_E[`rt])&IR_D[`rs]!=0)|(BOp!=4'b0011&(IR_D[`rt]==IR_E[`rt])&IR_D[`rt]!=0)))|
							(beq_D&ld_M&(((IR_D[`rs]==IR_M[`rt])&IR_D[`rs]!=0)|(BOp!=4'b0011&(IR_D[`rt]==IR_M[`rt])&IR_D[`rt]!=0)));
	 assign stall_cal_r=cal_r_D&ld_E&(((IR_D[`rs]==IR_E[`rt])&IR_D[`rs]!=0)|((IR_D[`rt]==IR_E[`rt])&IR_D[`rt]!=0));
	 assign stall_cal_i=cal_i_D&ld_E&(IR_D[`rs]==IR_E[`rt])&IR_D[`rs]!=0;
	 assign stall_ld=ld_D&ld_E&(IR_D[`rs]==IR_E[`rt])&IR_D[`rs]!=0;
	 assign stall_st=st_D&ld_E&(IR_D[`rs]==IR_E[`rt])&IR_D[`rs]!=0;
	 assign stall_jalr=(jalr_D&cal_r_E&(IR_D[`rs]==IR_E[`rd])&(IR_D[`rs]!=0))|
	                   (jalr_D&cal_i_E&(IR_D[`rs]==IR_E[`rt])&(IR_D[`rs]!=0))|
							 (jalr_D&ld_E&(IR_D[`rs]==IR_E[`rt])&(IR_D[`rs]!=0))|
							 (jalr_D&ld_M&(IR_D[`rs]==IR_M[`rt])&(IR_D[`rs]!=0));
	 assign stall_jr=(jr_D&cal_r_E&(IR_D[`rs]==IR_E[`rd])&(IR_D[`rs]!=0))|
	                 (jr_D&cal_i_E&(IR_D[`rs]==IR_E[`rt])&(IR_D[`rs]!=0))|
						  (jr_D&ld_E&(IR_D[`rs]==IR_E[`rt])&(IR_D[`rs]!=0))|
						  (jr_D&ld_M&(IR_D[`rs]==IR_M[`rt])&(IR_D[`rs]!=0));
	 assign stall_md=(busy|(md_E))&(md_D|mf_D|mt_D);
	 
	 assign stall=stall_beq|stall_cal_r|stall_cal_i|stall_ld|stall_st|stall_jalr|stall_jr|stall_md;
	 
	 assign en=~stall;
	 assign clr=stall;

endmodule
