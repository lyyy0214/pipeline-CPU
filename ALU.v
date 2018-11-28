`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:52:34 11/13/2016 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [4:0] op,
	 output reg ALURegW,
    output reg [31:0] Out
    );
	 
	 always@* begin
	 ALURegW<=0;
	 case(op)
	     5'b00000: Out<=A+B;  //add
		  5'b00001: Out<=A-B;   //sub
		  5'b00010: Out<=A|B;   //or
		  5'b00011: Out<={B[15:0],{16{1'b0}}};   //lui
		  5'b00100: Out<=B << A[4:0];  //A=s,B=rt sll
		  5'b00101: Out<=B >> A[4:0]; //srl
		  5'b00110: Out<=B&A;   //and
		  5'b00111: Out<=(A&~B)|(B&~A);    //xor
		  5'b01000: begin              //movz
		                Out<=A;
		                if(B==0)begin
							 ALURegW<=1;
						    end
						end
		  5'b01001: Out<=~(A|B);   //nor
		  5'b01010: Out<= $signed(B) >>> A[4:0]; //sra
		  5'b01011: Out<= ($signed(A)<$signed(B))?1:0;   //slt
		  5'b01100: Out<= (A<B)?1:0; //sltu
		  5'b01101: Out<= {{24{B[7]}},B[7:0]};//seb
		  default: Out<=0;
	 endcase
	 
	 end

endmodule
