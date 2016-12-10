`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/30 10:29:00
// Design Name: 
// Module Name: mesh_tb
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


module mesh_tb
  #(parameter IN_BIT = 8,
    parameter WEIGHT_BIT = 8,
    parameter OUT_BIT = 20,
    parameter MESH_X = 4,
    parameter MESH_Y = 4
    )
    (
    );
    
    reg clk=0;
    reg ena=0;
    reg signed [WEIGHT_BIT-1:0]weight_reg=0;
    reg signed [IN_BIT-1:0] data_reg_array [MESH_X*MESH_Y-1:0];
    reg signed [OUT_BIT-1:0]data_out_tb_reg_array[MESH_X*MESH_Y-1:0];
    wire [OUT_BIT*MESH_X*MESH_Y-1:0]data_out;
    
    always #10 clk=~clk;
    
    integer i;
    always @(posedge clk)
    begin
        for(i=0;i<MESH_X*MESH_Y;i=i+1)
            data_out_tb_reg_array[i]=(~rst_n?0:(ena?(data_out_tb_reg_array[i]+data_reg_array[i]*weight_reg):(data_out_tb_reg_array[i])));
        for(i=0;i<MESH_X*MESH_Y;i=i+1)
            data_reg_array[i]=$random;
        weight_reg=$random;
    end
    
    reg rst_n=1;
    initial
    begin
        @(posedge clk)
        rst_n=0;
        @(posedge clk)
        rst_n=1;
        ena=1;
    end
    
    wire [IN_BIT*MESH_X*MESH_Y-1:0] data_wire_in;
    wire [OUT_BIT-1:0]data_out_array[MESH_X*MESH_Y-1:0];
    generate
        genvar j;
        for(j=0;j<MESH_X*MESH_Y;j=j+1)
        begin:data_
            assign data_wire_in[(1+j)*IN_BIT-1:j*IN_BIT]=data_reg_array[j];
        end
        for(j=0;j<MESH_X*MESH_Y;j=j+1)
        begin:data__
            assign data_out_array[j]=data_out[(1+j)*OUT_BIT-1:j*OUT_BIT];
        end
    endgenerate
    
     Mesh #(
         .IN_BIT(IN_BIT),
         .WEIGHT_BIT(WEIGHT_BIT),
         .OUT_BIT(OUT_BIT),
         .MESH_X(MESH_X),
         .MESH_Y(MESH_Y)
         )
     mesh (
         .clk(clk),
         .rst_n(rst_n),
         .ena(ena),
         .data_in(data_wire_in),
         .weight(weight_reg),
         .data_out(data_out)
         );
         

   
endmodule
