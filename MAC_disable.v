`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/29 20:21:55
// Design Name: 
// Module Name: MAC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MAC
  #(parameter IN_BIT = 8,
	parameter WEIGHT_BIT = 8,
	parameter OUT_BIT = 20,
	parameter OP_BIT = 2)
   (input clk,
    input rst_n,
	input signed [IN_BIT-1:0] data_in,
	input signed [WEIGHT_BIT-1:0] weight,
	input [OP_BIT-1:0] op,
	output signed [OUT_BIT-1:0]data_out);
	
	wire [IN_BIT+WEIGHT_BIT-1:0] mul_result;
	reg [OUT_BIT-1:0]acc_result;
	assign mul_result=data_in*weight;
	assign data_out=acc_result;
	
	always @(posedge clk or negedge rst_n)
	begin
		if(~rst_n)
		  acc_result<=0;
		else
		  acc_result<={{(OUT_BIT-IN_BIT-WEIGHT_BIT){mul_result[IN_BIT+WEIGHT_BIT-1]}},mul_result}+acc_result;
	end
	
endmodule
