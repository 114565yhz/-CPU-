`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 14:19:39
// Design Name: 
// Module Name: PC
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


module PC(
    input wire clk,
    input wire rst,
    input wire stall,
    input wire [31:0] din,
    output reg [31:0] pc
    );


always @(posedge clk or posedge rst) begin
    if(rst==`RstEnable) begin
        pc <= 32'd0;
    end else if(stall) begin
        pc <= pc;
    end else begin
        pc <= din;
    end
end
//reg flag;
//always @(posedge clk or posedge rst) begin
//    if(rst==`RstEnable) begin
//        pc <= 32'd0;
//        flag <= 1;
//    end else if(flag==1) begin
//        pc <= 0;
//        flag <= 0;
//    end else if(stall) begin
//        pc <= pc;
//        flag <= flag;
//    end else begin
//        pc <= din;
//        flag <= flag;
//    end
//end

endmodule
