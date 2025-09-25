`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 16:45:32
// Design Name: 
// Module Name: ALU_input
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

module ALU_input_MUX(
    input wire [31:0] rD1,
    input wire [31:0] rD2,
    input wire [31:0] pc,
    input wire [31:0] sext,
    input wire [`ALUA_SEL_WIDTH-1:0] alua_sel,
    input wire [`ALUB_SEL_WIDTH-1:0] alub_sel,
    output reg [31:0] A,
    output reg [31:0] B
    );
    
always @(*) begin
    case (alua_sel) 
        `ALUA_SEL_RD1: A = rD1;
        `ALUA_SEL_PC: A = pc;
        default: A = 0;
    endcase
end

always @(*) begin
    case (alub_sel) 
        `ALUB_SEL_RD2: B = rD2;
        `ALUB_SEL_SEXT: B = sext;
        default:B=0;
    endcase
end

endmodule
