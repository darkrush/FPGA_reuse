`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/29 20:21:55
// Design Name: 
// Module Name: Mesh
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


module Mesh  
  #(parameter IN_BIT = 8,
	parameter WEIGHT_BIT = 8,
	parameter OUT_BIT = 20,
	parameter MESH_X = 4,
	parameter MESH_Y = 4
	)(
	input clk,
	input rst_n,
	input ena,
	input [MESH_X*MESH_Y*IN_BIT-1:0] data_in ,
	input [WEIGHT_BIT-1:0]weight,
	output [MESH_X*MESH_Y*OUT_BIT-1:0] data_out
    );
    
	genvar idx;
	generate
		for(idx=0;idx<MESH_Y*MESH_X;idx=idx+1)
		begin:mesh
			wire [IN_BIT-1:0]data_in_temp;
			wire [OUT_BIT-1:0]data_out_temp;
			assign data_in_temp=data_in[(1+idx)*IN_BIT-1:idx*IN_BIT];
			MAC #(
                .IN_BIT(IN_BIT),
                .WEIGHT_BIT(WEIGHT_BIT),
                .OUT_BIT(OUT_BIT)
                )
			mac (
                .clk(clk),
                .rst_n(rst_n),
                .ena(ena),
                .data_in(data_in_temp),
                .weight(weight),
                .data_out(data_out_temp)
                );
			assign data_out[(1+idx)*OUT_BIT-1:idx*OUT_BIT]=data_out_temp;
		end
    endgenerate
    

    
    
endmodule
