`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:51:06 11/13/2016 
// Design Name: 
// Module Name:    controller 
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
module controller(
    input [5:0] op,
	 input [4:0] rs,
	 input [4:0] rt,
    input [5:0] func,
    output [1:0] RegD,
	 output AluSA,
    output AluSB,
    output [1:0] MTR,
    output RegW,
    output MemW,
    output [1:0] Jump,
	 output Extend,
    output [4:0] ALUOp,
	 output [3:0] ALUXOp,
	 output [3:0] BOp,
	 output [2:0] LOp,
	 output cal_r,
	 output cal_i,
	 output B,
	 output ld,
	 output st,
	 output md,
	 output mf,
	 output mt,
	 output Mfc0,
	 output Mtc0,
	 output Eret,
	 output J,
	 output JAL,
	 output JALR,
	 output JR
    );
	 
	 wire addu,subu,lui,add,addiu,sub,sll,srl,sra,sllv,srlv,srav,And,Or,Xor,Nor,movz,slt,sltu,seb;
	 wire ori,addi,andi,xori,slti,sltiu;
	 wire sw,sb,sh,lw,lb,lbu,lh,lhu;
	 wire beq,bne,bgezal,blez,bltz,bgtz,bgez,j,jal,jalr,jr;
	 wire mult,multu,div,divu,mfhi,mflo,mthi,mtlo,madd;
	 wire mfc0,mtc0,eret;
	 
	 assign addu=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&func[5]&~func[4]&~func[3]&~func[2]&~func[1]&func[0];
	 assign add=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&func[5]&~func[4]&~func[3]&~func[2]&~func[1]&~func[0];
	 
	 assign subu=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&func[5]&~func[4]&~func[3]&~func[2]&func[1]&func[0];
	 assign sub=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&func[5]&~func[4]&~func[3]&~func[2]&func[1]&~func[0];
	 
	 assign addi=~op[5]&~op[4]&op[3]&~op[2]&~op[1]&~op[0];
	 assign addiu=~op[5]&~op[4]&op[3]&~op[2]&~op[1]&op[0];
	 
	 assign And=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&func[5]&~func[4]&~func[3]&func[2]&~func[1]&~func[0];
	 assign andi=~op[5]&~op[4]&op[3]&op[2]&~op[1]&~op[0];
	 
	 assign Or=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&func[5]&~func[4]&~func[3]&func[2]&~func[1]&func[0];
	 assign ori=~op[5]&~op[4]&op[3]&op[2]&~op[1]&op[0];

	 assign Xor=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&func[5]&~func[4]&~func[3]&func[2]&func[1]&~func[0];
	 assign xori=~op[5]&~op[4]&op[3]&op[2]&op[1]&~op[0];
	 
	 assign Nor=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&func[5]&~func[4]&~func[3]&func[2]&func[1]&func[0];
	 
	 assign sll=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&~func[4]&~func[3]&~func[2]&~func[1]&~func[0];
	 assign sllv=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&~func[4]&~func[3]&func[2]&~func[1]&~func[0];
	 
	 assign srl=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&~func[4]&~func[3]&~func[2]&func[1]&~func[0];
	 assign srlv=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&~func[4]&~func[3]&func[2]&func[1]&~func[0];
	 
	 assign sra=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&~func[4]&~func[3]&~func[2]&func[1]&func[0];
	 assign srav=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&~func[4]&~func[3]&func[2]&func[1]&func[0];
	 
	 assign slt=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&func[5]&~func[4]&func[3]&~func[2]&func[1]&~func[0];
	 assign slti=~op[5]&~op[4]&op[3]&~op[2]&op[1]&~op[0];
	 
	 assign sltu=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&func[5]&~func[4]&func[3]&~func[2]&func[1]&func[0];
	 assign sltiu=~op[5]&~op[4]&op[3]&~op[2]&op[1]&op[0];
	 
	 assign movz=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&~func[4]&func[3]&~func[2]&func[1]&~func[0];
	 
	 assign seb=~op[5]&op[4]&op[3]&op[2]&op[1]&op[0];
	 	 
	 assign lw=op[5]&~op[4]&~op[3]&~op[2]&op[1]&op[0];
	 assign lb=op[5]&~op[4]&~op[3]&~op[2]&~op[1]&~op[0];
	 assign lbu=op[5]&~op[4]&~op[3]&op[2]&~op[1]&~op[0];
	 assign lh=op[5]&~op[4]&~op[3]&~op[2]&~op[1]&op[0];
	 assign lhu=op[5]&~op[4]&~op[3]&op[2]&~op[1]&op[0];
	 
	 assign sw=op[5]&~op[4]&op[3]&~op[2]&op[1]&op[0];
	 assign sb=op[5]&~op[4]&op[3]&~op[2]&~op[1]&~op[0];
	 assign sh=op[5]&~op[4]&op[3]&~op[2]&~op[1]&op[0];
	 
	 assign beq=~op[5]&~op[4]&~op[3]&op[2]&~op[1]&~op[0];
	 assign bne=~op[5]&~op[4]&~op[3]&op[2]&~op[1]&op[0];
	 assign blez=~op[5]&~op[4]&~op[3]&op[2]&op[1]&~op[0];
	 assign bltz=~op[5]&~op[4]&~op[3]&~op[2]&~op[1]&op[0]&~rt[4]&~rt[3]&~rt[2]&~rt[1]&~rt[0];
	 assign bgez=~op[5]&~op[4]&~op[3]&~op[2]&~op[1]&op[0]&~rt[4]&~rt[3]&~rt[2]&~rt[1]&rt[0];
	 assign bgtz=~op[5]&~op[4]&~op[3]&op[2]&op[1]&op[0];
	 assign bgezal=~op[5]&~op[4]&~op[3]&~op[2]&~op[1]&op[0]&rt[4]&~rt[3]&~rt[2]&~rt[1]&rt[0];
	 
	 assign lui=~op[5]&~op[4]&op[3]&op[2]&op[1]&op[0];
	 
	 assign j=~op[5]&~op[4]&~op[3]&~op[2]&op[1]&~op[0];
	 assign jal=~op[5]&~op[4]&~op[3]&~op[2]&op[1]&op[0];
	 assign jr=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&~func[4]&func[3]&~func[2]&~func[1]&~func[0];
	 assign jalr=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&~func[4]&func[3]&~func[2]&~func[1]&func[0];
	 
	 assign mult=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&func[4]&func[3]&~func[2]&~func[1]&~func[0];
	 assign multu=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&func[4]&func[3]&~func[2]&~func[1]&func[0];
	 assign div=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&func[4]&func[3]&~func[2]&func[1]&~func[0];
	 assign divu=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&func[4]&func[3]&~func[2]&func[1]&func[0];
	 assign mfhi=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&func[4]&~func[3]&~func[2]&~func[1]&~func[0];
	 assign mflo=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&func[4]&~func[3]&~func[2]&func[1]&~func[0];
	 assign mthi=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&func[4]&~func[3]&~func[2]&~func[1]&func[0];
	 assign mtlo=~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5]&~func[5]&func[4]&~func[3]&~func[2]&func[1]&func[0];
	 assign madd=~op[5]&op[4]&op[3]&op[2]&~op[1]&~op[0];
	 
	 assign eret=~op[5]&op[4]&~op[3]&~op[2]&~op[1]&~op[0]&~func[5]&func[4]&func[3]&~func[2]&~func[1]&~func[0];
	 assign mfc0=~op[5]&op[4]&~op[3]&~op[2]&~op[1]&~op[0]&~rs[4]&~rs[3]&~rs[2]&~rs[1]&~rs[0];
	 assign mtc0=~op[5]&op[4]&~op[3]&~op[2]&~op[1]&~op[0]&~rs[4]&~rs[3]&rs[2]&~rs[1]&~rs[0];
	 
	 
	 assign RegD[0]=addu|subu|add|sub|sll|sllv|srl|srlv|sra|srav|And|Or|Xor|Nor|movz|slt|sltu|jalr|mfhi|mflo|seb;   // 00-rt 01-rd 10-31
	 assign RegD[1]=jal|bgezal;
	 assign RegW=addu|subu|ori|lw|lb|lbu|lh|lhu|lui|jal|jalr|add|addi|addiu|sub|sll|sllv|srl|srlv|sra|srav|And|andi|Or|Xor|xori|Nor|
	             slt|slti|sltu|sltiu|mfhi|mflo|seb|mfc0;
	 
	 assign MemW=sw|sb|sh;
	 assign AluSA=sll|srl|sra;
	 assign AluSB=ori|lw|lb|lbu|lh|lhu|sw|sb|sh|lui|addi|addiu|andi|xori|slti|sltiu;
	 assign Extend=lw|lb|lbu|lh|lhu|sw|sb|sh|addi|addiu|beq|bne|bgezal|blez|bltz|bgez|bgtz|slti|sltiu;
	 assign MTR[0]=lw|lb|lbu|lh|lhu|mfc0;
	 assign MTR[1]=jal|bgezal|jalr;
	 assign Jump[0]=beq|bne|bgezal|blez|bltz|bgez|bgtz|jr|jalr|bltz;
	 assign Jump[1]=j|jal|jr|jalr;
	 assign ALUOp[0]=subu|sub|lui|srl|Xor|xori|Nor|srlv|slt|slti|seb;
	 assign ALUOp[1]=ori|lui|And|andi|Or|Xor|xori|sra|srav|slt|slti;
	 assign ALUOp[2]=sll|srl|And|andi|Xor|xori|sllv|srlv|sltu|sltiu|seb;
	 assign ALUOp[3]=movz|Nor|sra|srav|slt|slti|sltu|sltiu|seb;
	 assign ALUOp[4]=0;
	 assign md=mult|multu|div|divu|madd;
	 assign mt=mtlo|mthi;
	 assign mf=mflo|mfhi;
	 assign ALUXOp[0]=multu|divu|mtlo|mflo;   //000-mult 001-multu 010-div 011-divu 100-mthi 101-mtlo 110-mfhi 111-mflo
	 assign ALUXOp[1]=div|divu|mfhi|mflo;
	 assign ALUXOp[2]=mthi|mtlo|mfhi|mflo;
	 assign ALUXOp[3]=madd;
	 assign BOp[0]=beq|bgezal|bltz|bgtz;    //BOp: 0001-beq 0010-bne 0011-bgezal  0100-blez 0101-bltz 0110-bgez 0111-bgtz
	 assign BOp[1]=bne|bgezal|bgez|bgtz;
	 assign BOp[2]=blez|bltz|bgez|bgtz;
	 assign BOp[3]=0;
	 assign LOp[0]=lb|lh;       //000-lw 001-lb 010-lbu 011-lh 100-lhu
	 assign LOp[1]=lbu|lh;
	 assign LOp[2]=lhu;
	 assign cal_r=addu|subu|add|sub|sll|sllv|srl|srlv|sra|srav|And|Or|Nor|Xor|
	              movz|slt|sltu|mult|multu|div|divu|mtlo|mthi|mflo|mfhi|madd|seb;
	 assign cal_i=ori|lui|addi|addiu|andi|xori|slti|sltiu;
	 assign ld=lw|lb|lbu|lh|lhu|mfc0;
	 assign st=sw|sb|sh;
	 assign B=beq|bne|bgezal|blez|bltz|bgez|bgtz;
	 assign J=j;
	 assign JAL=jal|bgezal;
	 assign JR=jr;
	 assign JALR=jalr;
	 assign Mfc0=mfc0;
	 assign Mtc0=mtc0;
	 assign Eret=eret;
	 
endmodule
