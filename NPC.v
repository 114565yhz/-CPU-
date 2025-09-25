`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 14:30:46
// Design Name: 
// Module Name: NPC
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

module NPC(
    input wire rst,
    input wire [31:0] PC,
    input wire [31:0] offset,
    input wire br,
    input wire [1:0] npc_op,
    input wire [31:0] alu_c,
    output reg [31:0] npc,
    output wire [31:0] pc4,
    output reg branched
    );

assign pc4 = PC + 4;

always @(*) begin
    case(npc_op) 
        //正常情况
        `NPC_SEL_NEXT: begin 
            npc = pc4;
            branched = 0;
        end
        //B型指令，需要加上偏移量
        `NPC_SEL_BRANCH: begin 
            if(br) begin
                npc = PC + offset - 8;
                branched = 1;
            end else begin
                npc = pc4;
                branched = 0;
            end
        end
        //jalr
        `NPC_SEL_ALU: begin   
            npc = alu_c;
            branched = 1;
        end
        //jal
        `NPC_SEL_JAL: begin 
            npc = PC + offset - 8;
            branched = 1;
        end
        default: begin 
            npc = 0;
            branched = 0;
        end
    endcase
end
endmodule
