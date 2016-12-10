`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/30 13:03:11
// Design Name: 
// Module Name: Adder_tree
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


module Adder_tree
    #(
    parameter IN_BIT   = 20,
    parameter OUT_BIT  = 32,
    parameter MESH_X    = 8,
    parameter MESH_Y    = 8,
    parameter MESH_N    =64
    )
    (
    input clk,
    input ena,
    input rst_n,
    input [MESH_N*MESH_X*MESH_Y*IN_BIT-1:0]data_in,
    input[MESH_X*MESH_Y*OUT_BIT-1:0]inter_data,
    output [MESH_X*MESH_Y*OUT_BIT-1:0]data_out
    );
    wire [MESH_N*MESH_X*MESH_Y*OUT_BIT-1:0]ext_data_in;
    wire [MESH_X*MESH_Y*OUT_BIT-1:0]ext_inter_data_in;
    wire [MESH_X*MESH_Y*OUT_BIT-1:0] data_in_array0[MESH_N-1:0];
    wire [MESH_X*MESH_Y*OUT_BIT-1:0] data_in_array1[MESH_N/2-1:0];
    wire [MESH_X*MESH_Y*OUT_BIT-1:0] data_in_array2[MESH_N/4-1:0];
    wire [MESH_X*MESH_Y*OUT_BIT-1:0] data_in_array3[MESH_N/8-1:0];
    wire [MESH_X*MESH_Y*OUT_BIT-1:0] data_in_array4[MESH_N/16-1:0];
    wire [MESH_X*MESH_Y*OUT_BIT-1:0] data_in_array5[MESH_N/32-1:0];
    wire [MESH_X*MESH_Y*OUT_BIT-1:0] data_in_array6;
    wire [MESH_X*MESH_Y*OUT_BIT-1:0] data_out_array;
    
    generate
        genvar i_0;
        for(i_0=0;i_0<MESH_X*MESH_Y*MESH_N;i_0=i_0+1)
        begin:sign_ext0
            assign ext_data_in[(i_0+1)*OUT_BIT-1:i_0*OUT_BIT]=$signed(data_in[(i_0+1)*IN_BIT-1:i_0*IN_BIT]);
        end
        for(i_0=0;i_0<MESH_X*MESH_Y;i_0=i_0+1)
        begin:sign_ext1
            assign ext_inter_data_in[(i_0+1)*OUT_BIT-1:i_0*OUT_BIT]=$signed(inter_data[(i_0+1)*IN_BIT-1:i_0*IN_BIT]);
        end
        for(i_0=0;i_0<MESH_N;i_0=i_0+1)
        begin:sign
            assign data_in_array0[i_0]=ext_data_in[(i_0+1)*MESH_X*MESH_Y*OUT_BIT-1:i_0*MESH_X*MESH_Y*OUT_BIT];
        end
        
        for(i_0=0;i_0<32;i_0=i_0+1)
        begin:adders_0
            Adder_mesh mesh0(.data_in0(data_in_array0[i_0*2]),.data_in1(data_in_array0[i_0*2+1]),.rst_n(rst_n), .data_out(data_in_array1[i_0]));
        end
        for(i_0=0;i_0<16;i_0=i_0+1)
        begin:adders_1
            Adder_mesh mesh1(.data_in0(data_in_array1[i_0*2]),.data_in1(data_in_array1[i_0*2+1]),.rst_n(rst_n), .data_out(data_in_array2[i_0]));
        end
        for(i_0=0;i_0<8;i_0=i_0+1)
        begin:adders_2
            Adder_mesh mesh2(.data_in0(data_in_array2[i_0*2]),.data_in1(data_in_array2[i_0*2+1]),.rst_n(rst_n), .data_out(data_in_array3[i_0]));
        end
        for(i_0=0;i_0<4;i_0=i_0+1)
        begin:adders_3
            Adder_mesh mesh3(.data_in0(data_in_array3[i_0*2]),.data_in1(data_in_array3[i_0*2+1]),.rst_n(rst_n), .data_out(data_in_array4[i_0]));
        end
        for(i_0=0;i_0<2;i_0=i_0+1)
        begin:adders_4
            Adder_mesh mesh4(.data_in0(data_in_array4[i_0*2]),.data_in1(data_in_array4[i_0*2+1]),.rst_n(rst_n), .data_out(data_in_array5[i_0]));
        end
        
        Adder_mesh mesh5(.data_in0(data_in_array5[0]),.data_in1(data_in_array5[1]),.rst_n(rst_n), .data_out(data_in_array6));
        Adder_mesh mesh6(.data_in0(data_in_array6),.data_in1(ext_inter_data_in),.rst_n(rst_n), .data_out(data_out_array));
    endgenerate
    assign data_out=data_out_array;
endmodule

