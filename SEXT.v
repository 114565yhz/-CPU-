`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 14:44:39
// Design Name: 
// Module Name: SEXT
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

module SEXT(
    input wire [24:0] din,
    input wire [`Sext_OP_WDITH-1:0] sext_op,
    output reg [31:0] sext
    );
    
always @(*) begin
    case(sext_op)
        `Sext_I: sext = {{20{din[24]}}, din[24:13]};
        `Sext_S: sext = {{20{din[24]}}, din[24:18], din[4:0]};
        `Sext_B: sext = {{20{din[24]}}, din[0], din[23:18], din[4:1], {1'b0}};
        `Sext_U: sext = {din[24:5], 12'b0};
        `Sext_J: sext = {{12{din[24]}}, din[12:5], din[13], din[23:14], {1'b0}};
        default: sext = 0;
    endcase 
end


endmodule
