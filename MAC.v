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


module MAC
    #(parameter IN_BIT = 8,
      parameter WEIGHT_BIT = 8,
      parameter OUT_BIT = 20
      )
     (input clk,
      input rst_n,
      input ena,
      input signed [IN_BIT-1:0] data_in,
      input signed [WEIGHT_BIT-1:0] weight,
      output signed [OUT_BIT-1:0]data_out);
      
      wire [IN_BIT+WEIGHT_BIT-1:0] mul_result;
      wire [47:0]acc_result;

      xbip_multadd_0 mac(.A(data_in),.B(weight),.CLK(clk),.SCLR(~rst_n),.CE(ena),.SUBTRACT(1'b0),.P(data_out),.PCOUT(acc_result),.PCIN(acc_result)); 
    
    
endmodule
