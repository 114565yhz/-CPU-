`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 15:15:20
// Design Name: 
// Module Name: ALU
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

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [`ALU_OP_WIDTH-1:0] alu_op,
    //运算结果
    output reg [31:0] alu_c,
    //结果标志位
    output reg alu_f
    );


always @(*) begin
    case (alu_op)
        `ALU_ADD: begin alu_c = A + B; alu_f = 0; end
        `ALU_SUB: begin alu_c = A + (~B + 1); alu_f = 0; end
        `ALU_AND: begin alu_c = A & B; alu_f = 0; end
        `ALU_OR: begin alu_c = A | B; alu_f = 0; end
        `ALU_XOR: begin alu_c = A ^ B; alu_f = 0; end
        `ALU_SLL: begin alu_c = A << B[4:0]; alu_f = 0; end
        `ALU_SRL: begin alu_c = A >> B[4:0]; alu_f = 0; end
        `ALU_SRA: begin alu_c = ($signed(A)) >>> B[4:0]; alu_f = 0; end
        `ALU_SLT: begin alu_c = (($signed(A)) < ($signed(B))) ? 1:0; alu_f = 0; end
        `ALU_SLTU: begin alu_c = (A<B) ? 1:0; alu_f = 0; end
        `ALU_BEQ: begin 
            if(A == B) begin
                alu_f = 1;
            end else begin
                alu_f = 0;
            end
        end
        `ALU_BNE: begin
            if(A == B) begin
                alu_f = 0;
            end else begin
                alu_f = 1;
            end
        end
        `ALU_BLT: begin
            if($signed(A)<$signed(B)) begin
                alu_f = 1;
            end else begin
                alu_f = 0;
            end
        end
        `ALU_BLTU: begin
            if(A < B) begin
                alu_f = 1;
            end else begin
                alu_f = 0;
            end
        end
        `ALU_BGE: begin
            if($signed(A) >= $signed(B)) begin
                alu_f = 1;
            end else begin
                alu_f = 0;
            end
        end
        `ALU_BGEU: begin
            if(A >= B) begin
                alu_f = 1;
            end else begin
                alu_f = 0;
            end
        end
        default: begin alu_c = 0; alu_f = 0; end
    endcase
end

endmodule
