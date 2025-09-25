`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/11 09:33:53
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input                           clk          ,
    input                           rst          ,
    input                           ex_rf_we     ,
    input                           ex_ram_we    ,
    input [31:0]                    ex_alu_c     ,
    input [`DRAM_SEL_WIDTH-1:0]     ex_dram_sel  ,
    input [`RF_WSEL_WIDTH-1:0]      ex_rf_wsel   ,
    input [31:0]                    ex_rD2       ,
    input [4:0]                     ex_wR        ,
    input [31:0]                    ex_wD        ,
    output reg                      mem_rf_we    ,
    output reg                      mem_ram_we   ,
    output reg [31:0]               mem_alu_c    ,
    output reg [31:0]               mem_rD2      ,
    output reg [`DRAM_SEL_WIDTH-1:0]mem_dram_sel ,
    output reg [`RF_WSEL_WIDTH-1:0] mem_rf_wsel  ,
    output reg [4:0]                mem_wR       ,
    output reg [31:0]               mem_wD_temp
    
    //trace
//    ,input  wire [31:0] pc_i       ,
//    output reg  [31:0] pc_o       ,
//    input  wire        have_inst_i,
//    output reg         have_inst_o
    );

always @(posedge clk or posedge rst) begin
    if(rst) begin
        mem_rf_we    <= 0;
        mem_ram_we   <= 0;
        mem_alu_c    <= 0;
        mem_rD2      <= 0;
        mem_dram_sel <= 0;
        mem_rf_wsel  <= 0;
        mem_wR       <= 0;
        mem_wD_temp       <= 0;
    end else begin
        mem_rf_we    <= ex_rf_we   ;
        mem_ram_we   <= ex_ram_we  ;
        mem_alu_c    <= ex_alu_c   ;
        mem_rD2      <= ex_rD2     ;
        mem_dram_sel <= ex_dram_sel;
        mem_rf_wsel  <= ex_rf_wsel ;
        mem_wR       <= ex_wR      ;
        mem_wD_temp       <= ex_wD      ;
    end
end

//trace
//always @ (posedge clk or posedge rst) begin
//    if (rst) pc_o <= 32'b0;
//    else        pc_o <= pc_i;
//end
//always @ (posedge clk or posedge rst) begin
//    if (rst) have_inst_o <= 1'b0;
//    else        have_inst_o <= have_inst_i;
//end
endmodule
