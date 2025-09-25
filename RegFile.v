`timescale 1ns / 1ps

`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 11:28:04
// Design Name: 
// Module Name: RegFile
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
`include "defines.vh"

module RegFile(
    input rst,
    input clk,
    input wire [`RegAddrBus] rR1,
    input wire [`RegAddrBus] rR2,
    input wire [`RegAddrBus] wR,
    input wire we,
    input wire [`RegBus] wD,
    output reg [`RegBus] rD1,
    output reg [`RegBus] rD2
    );
    
    
 reg [`RegBus] regs [0:`RegNum-1];
 always @(*) begin
    if(rst==`RstEnable) begin
        rD1 = 0;
        rD2 = 0;
    end else begin
        rD1 = regs[rR1];
        rD2 = regs[rR2];
    end
 end
 
 always @(posedge clk) begin
     //如果有写使能且写入的寄存器不是x0
    if(rst==`RstDisable) begin
        if(wR==0) begin
            regs[wR] <= 0;
        end else if (we) begin
            regs[wR] <= wD;
        end else begin
            regs[wR] <= regs[wR];
        end
    end else begin
        regs[0] <= 0;
        regs[1] <= 0;
        regs[2] <= 0;
        regs[3] <= 0;
        regs[4] <= 0;
        regs[5] <= 0;
        regs[6] <= 0;
        regs[7] <= 0;
        regs[8] <= 0;
        regs[9] <= 0;
        regs[10] <= 0;
        regs[11] <= 0;
        regs[12] <= 0;
        regs[13] <= 0;
        regs[14] <= 0;
        regs[15] <= 0;
        regs[16] <= 0;
        regs[17] <= 0;
        regs[18] <= 0;
        regs[19] <= 0;
        regs[20] <= 0;
        regs[21] <= 0;
        regs[22] <= 0;
        regs[23] <= 0;
        regs[24] <= 0;
        regs[25] <= 0;
        regs[26] <= 0;
        regs[27] <= 0;
        regs[28] <= 0;
        regs[29] <= 0;
        regs[30] <= 0;
        regs[31] <= 0;
    end
 end
 
endmodule
