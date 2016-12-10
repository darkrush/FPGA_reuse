`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/30 16:38:46
// Design Name: 
// Module Name: PE_tb
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


module PE_tb(

    );
    reg clk=0;    
    reg ena=1;
    reg rst_n=1;
    reg data_valid=0;
    reg [1:0]op=2'b00;
    reg signed [8*8*32-1:0] inter_data_array;
   // reg signed [8-1:0] data_array[64*8*8-1:0];
    reg signed [32-1:0] data_out_tb_array[8*8-1:0];    
    reg signed [8-1:0] feature_map[10*10*64-1:0];
    reg signed [8-1:0] weight_array[3*3*64-1:0];
    reg [3:0]clk_num=-1;
    always #10 clk=~clk;
    initial
    begin
        #3 rst_n=0;
        #7 data_valid=1;
        #20 rst_n=1;
        #180 data_valid=0;
    end   
    
    wire [8*8*32-1:0]data_out;
    reg [8*64-1:0]weight_line;
    wire [8*3*3*64-1:0]weight;
    wire [32-1:0]data_out_array[8*8-1:0];
    wire [32*8*8-1:0]inter_data;
    wire [64*8*8*8-1:0] data_in;
    wire [32-1:0] data_out_sub_array[8*8-1:0];
    wire [3*3*8*8*64*8-1:0] data_win;
    generate
        genvar i;
        genvar cx,cy,ch;
        for(ch=0;ch<64;ch=ch+1)
        for(cx=0;cx<8;cx=cx+1)
            for(cy=0;cy<8;cy=cy+1)
            begin:data_mux
                wire [8*3*3-1:0]temp_in;
                assign temp_in={feature_map[cx+cy*10+ch*10*10],
                                feature_map[cx+1+cy*10+ch*10*10],
                                feature_map[cx+2+cy*10+ch*10*10],
                                
                                feature_map[cx+(cy+1)*10+ch*10*10],
                                feature_map[cx+1+(cy+1)*10+ch*10*10],
                                feature_map[cx+2+(cy+1)*10+ch*10*10],
                                
                                feature_map[cx+cy*10+ch*10*10],
                                feature_map[cx+1+(cy+2)*10+ch*10*10],
                                feature_map[cx+2+(cy+2)*10+ch*10*10]
                                };
                Mux_3x3 mux3x3(.in_data(temp_in),.out_data(data_in[(cx+cy*8+ch*8*8+1)*8-1:(cx+cy*8+ch*8*8)*8]),.num(clk_num));
            end
        for(i=0;i<8*8;i=i+1)
        begin:inter_
            assign data_out_array[i]=data_out[(i+1)*32-1:i*32];
            assign data_out_sub_array[i]=data_out_tb_array[i]-data_out_array[i];
            //assign inter_data[(1+i)*32-1:i*32]=inter_data_array[i];
        end
        //for(i=0;i<64*8*8;i=i+1)
        //begin:in_data_
        //    assign data_in[(1+i)*8-1:i*8]=data_array[i];
        //end
        for(i=0;i<3*3*64;i=i+1)
        begin:weight_data_
            assign weight[(1+i)*8-1:i*8]=weight_array[i];
        end              
    endgenerate
    
    integer iter,x,y;
    initial
    begin
        #3 rst_n=0;
        #20 rst_n=1;
        for(iter=0;iter<10*10*64;iter=iter+1)
            feature_map[iter]=$random;
        for(iter=0;iter<3*3*64;iter=iter+1)
            weight_array[iter]=$random;
        for(iter=0;iter<8*8*32;iter=iter+1)
            inter_data_array[iter]=0;
        for(x=0;x<8;x=x+1)
        for(y=0;y<8;y=y+1)
        begin
            data_out_tb_array[x+y*8]=0;
            for(iter=0;iter<64;iter=iter+1)
            begin
                data_out_tb_array[x+y*8]=data_out_tb_array[x+y*8]+feature_map[x+y*10+0+iter*10*10]*weight_array[0+iter];
                data_out_tb_array[x+y*8]=data_out_tb_array[x+y*8]+feature_map[x+y*10+1+iter*10*10]*weight_array[1*64+iter];
                data_out_tb_array[x+y*8]=data_out_tb_array[x+y*8]+feature_map[x+y*10+2+iter*10*10]*weight_array[2*64+iter];
                
                data_out_tb_array[x+y*8]=data_out_tb_array[x+y*8]+feature_map[x+y*10+10+iter*10*10]*weight_array[3*64+iter];
                data_out_tb_array[x+y*8]=data_out_tb_array[x+y*8]+feature_map[x+y*10+11+iter*10*10]*weight_array[4*64+iter];
                data_out_tb_array[x+y*8]=data_out_tb_array[x+y*8]+feature_map[x+y*10+12+iter*10*10]*weight_array[5*64+iter];
                
                data_out_tb_array[x+y*8]=data_out_tb_array[x+y*8]+feature_map[x+y*10+20+iter*10*10]*weight_array[6*64+iter];
                data_out_tb_array[x+y*8]=data_out_tb_array[x+y*8]+feature_map[x+y*10+21+iter*10*10]*weight_array[7*64+iter];
                data_out_tb_array[x+y*8]=data_out_tb_array[x+y*8]+feature_map[x+y*10+22+iter*10*10]*weight_array[8*64+iter];
            end
        end   
    end
    
    always @(posedge clk)
    begin
        clk_num=(clk_num==8)?0:clk_num+1;
        inter_data_array<=(data_valid==1'b1)?data_out:inter_data_array;
    end
    always @(*)
    begin
        case(clk_num)
        4'd0:weight_line=weight[8*64*(0+1)-1:8*64*0];
        4'd1:weight_line=weight[8*64*(1+1)-1:8*64*1];
        4'd2:weight_line=weight[8*64*(2+1)-1:8*64*2];
        4'd3:weight_line=weight[8*64*(3+1)-1:8*64*3];
        4'd4:weight_line=weight[8*64*(4+1)-1:8*64*4];
        4'd5:weight_line=weight[8*64*(5+1)-1:8*64*5];
        4'd6:weight_line=weight[8*64*(6+1)-1:8*64*6];
        4'd7:weight_line=weight[8*64*(7+1)-1:8*64*7];
        4'd8:weight_line=weight[8*64*(8+1)-1:8*64*8];
        default:weight_line=0; 
        endcase
    end
            


    
    PE pe(clk,rst_n,ena,data_valid,
        data_in,
        weight_line,
        data_out,
        op,
        inter_data_array
        );
    
    
endmodule

