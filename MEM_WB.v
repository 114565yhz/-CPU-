`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/11 09:51:08
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input                       clk       ,
    input                       rst       ,
    input                       mem_rf_we ,
    input [4:0]                mem_wR    ,
    input [31:0]                mem_wD    ,
    output reg                  wb_rf_we  ,
    output reg [4:0]           wb_wR     ,
    output reg [31:0]           wb_wD
    
    //trace
//    ,input  wire [31:0] pc_i       ,
//    output reg  [31:0] pc_o       ,
//    input  wire        have_inst_i,
//    output reg         have_inst_o
    );

always @(posedge clk or posedge rst) begin
    if(rst) begin
        wb_rf_we <= 0;
        wb_wR    <= 0;
        wb_wD    <= 0;
    end else begin
        wb_rf_we <= mem_rf_we ;
        wb_wR    <= mem_wR    ;
        wb_wD    <= mem_wD    ;
    end
end


//trace
//always @ (posedge clk or posedge rst) begin
//    if (rst) pc_o <= 32'b0;
//    else        pc_o <= pc_i;
//end
//always @ (posedge clk or posedge rst) begin
//    if (rst) have_inst_o <= 1'b0;
//    else     have_inst_o <= have_inst_i;
//end
endmodule
