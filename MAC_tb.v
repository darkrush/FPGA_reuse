`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/29 20:55:44
// Design Name: 
// Module Name: MAC_tb
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


module MAC_tb
  #(parameter IN_BIT = 8,
	parameter WEIGHT_BIT = 8,
	parameter OUT_BIT = 20
    )
    (

    );
    reg clk=0;
    reg ena=1;
    reg signed [WEIGHT_BIT:0]weight;
    reg signed [IN_BIT-1:0]data;
    reg signed [OUT_BIT-1:0] result;
    wire [OUT_BIT-1:0]data_out;
    always #10 clk=~clk;
    always @(posedge clk)
    begin
        result<=rst_n?(data*weight+result):0;
        data<=$random;
        weight<=$random;
    end
    
    reg rst_n=1;
    initial begin
    @(posedge clk);
    rst_n = 0;
    @(posedge clk);
    rst_n = 1;
    
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);

    rst_n = 0;
    @(posedge clk);
    rst_n = 1;
    
    end

    MAC 
      #(.IN_BIT(IN_BIT),
        .WEIGHT_BIT(WEIGHT_BIT),
        .OUT_BIT(OUT_BIT)
        )
        mac1
       (.clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .data_in(data),
        .weight(weight),
        .data_out(data_out));
    
endmodule
