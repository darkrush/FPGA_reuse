`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/29 20:21:55
// Design Name: 
// Module Name: PE
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


module PE
  #(parameter IN_BIT = 8,
	parameter WEIGHT_BIT = 8,
	parameter MESH_OUT_BIT = 20,
    parameter OUT_BIT = 32,
	parameter MESH_X = 8,
	parameter MESH_Y = 8,
	parameter MESH_N = 64
	)(
	input clk,
	input rst_n,
	input ena,
	input data_valid,
	input [MESH_N*MESH_X*MESH_Y*IN_BIT-1:0] data_in,
	input [MESH_N*WEIGHT_BIT-1:0]weight,
	output [MESH_X*MESH_Y*OUT_BIT-1:0] data_out,
	input [MESH_X*MESH_Y*OUT_BIT-1:0] inter_data
    );
	wire [MESH_N*MESH_X*MESH_Y*MESH_OUT_BIT-1:0] data_out_mesh;
	genvar idx;
	generate
		for(idx=0;idx<MESH_N;idx=idx+1)
		begin:pe
			wire [MESH_X*MESH_Y*IN_BIT-1:0]data_in_temp;
			wire [MESH_X*MESH_Y*MESH_OUT_BIT-1:0]data_out_temp;
			wire [WEIGHT_BIT-1:0]weight_temp;
			assign data_in_temp=data_in[(1+idx)*MESH_X*MESH_Y*IN_BIT-1:idx*MESH_X*MESH_Y*IN_BIT];
			assign weight_temp=weight[(1+idx)*WEIGHT_BIT-1:idx*WEIGHT_BIT];
			
			Mesh#(
                .IN_BIT(IN_BIT),
                .WEIGHT_BIT(WEIGHT_BIT),
                .OUT_BIT(MESH_OUT_BIT),
                .MESH_X(MESH_X),
                .MESH_Y(MESH_Y)
                )
			mesh(
                .clk(clk),
                .rst_n(rst_n),
                .ena(ena),
                .data_in(data_in_temp),
                .weight(weight_temp),
                .data_out(data_out_temp)
                );
			assign data_out_mesh[(1+idx)*MESH_X*MESH_Y*MESH_OUT_BIT-1:idx*MESH_X*MESH_Y*MESH_OUT_BIT]=data_out_temp;
		end
    endgenerate
	Adder_tree_param#(
	    .IN_BIT(MESH_OUT_BIT),
        .OUT_BIT(OUT_BIT),
        .MESH_X(MESH_X),
        .MESH_Y(MESH_Y),
        .MESH_N(MESH_N)
        )
	adder_tree(
	   .clk(clk),
	   .ena(ena),
	   .rst_n(rst_n),
	   .data_in(data_out_mesh),
	   .inter_data(inter_data),
	   .data_out(data_out)
	   );
	
endmodule
