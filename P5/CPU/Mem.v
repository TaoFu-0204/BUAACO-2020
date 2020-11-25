`timescale 1ns / 1ps
`include "CPU_Param.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:54:21 11/25/2020 
// Design Name: 
// Module Name:    Mem 
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
module Mem(
	input wire [4:0] Rs_EX_to_Mem,
    input wire [4:0] Rt_EX_to_Mem,
    input wire [4:0] RegWriteAddr_EX_to_Mem,
	input wire [59:0] InstrType_EX_to_Mem,
	input wire [31:0] ALUOut_EX_to_Mem,
	input wire [31:0] DMWriteData_EX_to_Mem, //��д��DM������
	input wire [31:0] PC_EX_to_Mem,
	input wire clk,
	input wire reset,
	
	output reg [31:0] ALUOut_Mem_to_WB,
	output reg [31:0] DMRead_Mem_to_WB,
	output reg [4:0] RegWriteAddr_Mem_to_WB,
	output reg [31:0] PC_Mem_to_WB
    );
	wire [59:0] InstrType;
	wire [31:0] DMRead_wire, DMWriteData_bypass;
	wire DMWriteEn;
	assign DMWriteData_bypass = DMWriteData_EX_to_Mem;
	assign InstrType = InstrType_EX_to_Mem;
	assign DMWriteEn = (`sw) ? 1 : 0;
	
	DM DM(
	.Addr(ALUOut_EX_to_Mem),
    .WData(DMWriteData_bypass),
    .MemWrite(DMWriteEn),//дʹ���ź�
    .clk(clk),
    .reset(reset),
	.WritePC(PC_EX_to_Mem),
    .RData(DMRead_wire));
	
	always@(posedge clk)
	begin
		if(reset)
		begin
			ALUOut_Mem_to_WB <= 32'd0;
			DMRead_Mem_to_WB <= 32'd0;
			RegWriteAddr_Mem_to_WB <= 5'd0;
			PC_Mem_to_WB <= 32'h0000_3000;
		end
		else
		begin
			ALUOut_Mem_to_WB <= ALUOut_EX_to_Mem;
			DMRead_Mem_to_WB <= DMRead_wire;
			RegWriteAddr_Mem_to_WB <= RegWriteAddr_EX_to_Mem;
			PC_Mem_to_WB <= PC_EX_to_Mem;
		end
	end

endmodule
