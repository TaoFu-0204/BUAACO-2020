`timescale 1ns / 1ps
`include "CPU_Param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:53:46 11/25/2020 
// Design Name: 
// Module Name:    AT_Cal 
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
module AT_Cal(
    input wire [4:0] Rs,
	input wire [4:0] Rt,
	input wire [4:0] Rd,
    input wire [59:0] InstrType,
	output reg [4:0] RAddr0,
	output reg [4:0] RAddr1,
	output reg [4:0] WAddr,
	output reg [2:0] Tuse_RAddr0,// Ҫ�õ���ʱ��
	output reg [2:0] Tuse_RAddr1,// ����ʱ��
	output reg [2:0] Tnew_Waddr
    );
	wire typeR, load, save, branch;
	assign typeR = `addu || `subu || `sll;
	//R�ͼ���ָ��
	assign load = `lw;
	assign save = `sw;
	assign branch = `beq;
	//ע�⣺bgez��Ҫ����������Rt�ֶη�0�����ָ�
	
	always@(*)
	begin
		if(typeR)
		begin
			RAddr0 <= Rs;
			RAddr1 <= Rt;
			WAddr <= Rd;
			Tuse_RAddr0 <= 3'd1;
			Tuse_RAddr1 <= 3'd1;
			Tnew_Waddr <= 3'd1;
		end
		else if(load)
		begin
			RAddr0 <= Rs;
			RAddr1 <= 5'd0;
			WAddr <= Rt;
			Tuse_RAddr0 <= 3'd1;
			Tuse_RAddr1 <= 3'd7; //Rt����������
			Tnew_Waddr <= 3'd2;
		end
		else if(save)
		begin
			RAddr0 <= Rs;
			RAddr1 <= Rt;
			WAddr <= 5'd0;
			Tuse_RAddr0 <= 3'd1;
			Tuse_RAddr1 <= 3'd2;
			Tnew_Waddr <= 3'd0; // ����д����
		end
		else if(branch)
		begin
			RAddr0 <= Rs;
			RAddr1 <= Rt;
			WAddr <= 5'd0;
			Tuse_RAddr0 <= 3'd0;
			Tuse_RAddr1 <= 3'd0; //������Ҫ
			Tnew_Waddr <= 3'd0; //��д
		end
		else if(`lui)
		begin
			RAddr0 <= 5'd0;
			RAddr1 <= 5'd0;
			WAddr <= Rt;
			Tuse_RAddr0 <= 3'd7;//Rs����������
			Tuse_RAddr1 <= 3'd7;//Rt����������
			Tnew_Waddr <= 3'd0; //ֵ�ڵ�ǰ��ˮ�Ѳ���
		end
		else if(`jal)
		begin
			RAddr0 <= 5'd0;
			RAddr1 <= 5'd0;
			WAddr <= 5'd31; //д31�żĴ���
			Tuse_RAddr0 <= 3'd7;//Rs����������
			Tuse_RAddr1 <= 3'd7;//Rt����������
			Tnew_Waddr <= 3'd1; //ֵ��EX����
		end
		else if(`jr)
		begin
			RAddr0 <= Rs;
			RAddr1 <= 5'd0;
			WAddr <= 5'd0; //��д
			Tuse_RAddr0 <= 3'd0;//������ҪRs
			Tuse_RAddr1 <= 3'd7;//Rt����������
			Tnew_Waddr <= 3'd0; //��д
		end
		else if(`j)
		begin
			RAddr0 <= 5'd0;
			RAddr1 <= 5'd0;
			WAddr <= 5'd0;
			Tuse_RAddr0 <= 3'd7;//Rs����������
			Tuse_RAddr1 <= 3'd7;//Rt����������
			Tnew_Waddr <= 3'd0; //��д
		end
	end
	

endmodule
