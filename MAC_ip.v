`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/30 11:13:13
// Design Name: 
// Module Name: MAC_ip
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


module MAC_ip
    #(parameter IN_BIT = 8,
      parameter WEIGHT_BIT = 8,
      parameter OUT_BIT = 20,
      parameter OP_BIT = 2)
     (input clk,
      input rst_n,
      input ena,
      input signed [IN_BIT-1:0] data_in,
      input signed [WEIGHT_BIT-1:0] weight,
      input [OP_BIT-1:0] op,
      output signed [OUT_BIT-1:0]data_out);
      
      wire [IN_BIT+WEIGHT_BIT-1:0] mul_result;
      wire [47:0]acc_result;
//      wire [OUT_BIT-1:0]acc_result_temp;
      xbip_multadd_0 mac(.A(data_in),.B(weight),.SUBTRACT(1'b1),.P(data_out),.PCOUT(acc_result),.PCIN(acc_result)); 
      //xbip_multadd_0 mac(.CLK(clk),.CE(ena),.SCLR(~rst_n),.A(data_in),.B(weight),.P(data_out),.PCOUT(acc_result),.PCIN(acc_result));
      //always @(posedge clk or negedge rst_n)
      //begin
      //   if(~rst_n)
      //     acc_result<=0;
      //   else
      //     acc_result<=acc_result_temp;
      //end
    
    
endmodule
