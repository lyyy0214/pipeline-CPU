`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:26:01 12/20/2016 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	 
	 wire PrWE,IRQ0,IRQ1,DEV0_WE,DEV1_WE;
	 wire [31:0] PrRD,PrAddr,DEV_Addr,PrWD;
	 wire [31:0] DEV0_RD,DEV1_RD,DEV_RD,DEV_WD;
	 wire [7:2] HWInt;
	 
	 cpu cpu(clk,reset,PrRD,HWInt,PrAddr,PrWD,PrWE);
	 
	 assign HWInt[2]=IRQ0;
	 assign HWInt[3]=IRQ1;
	 assign HWInt[7:4]=0;
	 
	 bridge bridge(PrWE,PrAddr,DEV0_RD,DEV1_RD,PrWD,DEV0_WE,DEV1_WE,DEV_Addr,PrRD,DEV_WD);
	 
	 
    timer timer0(clk,reset,DEV0_WE,DEV_Addr,DEV_WD,DEV0_RD,IRQ0);
	 timer timer1(clk,reset,DEV1_WE,DEV_Addr,DEV_WD,DEV1_RD,IRQ1);
	 //input:写使能信号，32地址，32位数据 output:2个timer的输出数据和中断请求
	 
	 
endmodule
