`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/11 09:11:34
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input                               clk          ,
    input                               rst          ,
    input                               flush        ,
    input [`ALU_OP_WIDTH-1:0]           id_alu_op    ,
    input                               id_rf_we     ,
    input                               id_ram_we    ,
    input [`RF_WSEL_WIDTH-1:0]          id_rf_wsel   ,
    input [`DRAM_SEL_WIDTH-1:0]         id_dram_sel  ,
    input [31:0]                        id_rD2       ,
    input [31:0]                        id_pc4       ,
    input [`NPC_SEL_WIDTH-1:0]          id_npc_op    ,
    input [31:0]                        id_sext      ,
    input [31:0]                        id_A         ,
    input [31:0]                        id_B         ,
    input [4:0]                         id_wR        ,
    input                               Forward_A_en ,
    input                               Forward_B_en ,
    input [31:0]                        A_forward    ,
    input [31:0]                        B_forward    ,
    output reg [`ALU_OP_WIDTH-1:0]      ex_alu_op    ,
    output reg                          ex_rf_we     ,
    output reg                          ex_ram_we    ,
    output reg [`RF_WSEL_WIDTH-1:0]     ex_rf_wsel   ,
    output reg [`DRAM_SEL_WIDTH-1:0]    ex_dram_sel  ,
    output reg [`RegBus]                ex_rD2       ,
    output reg [31:0]                   ex_sext      ,
    output reg [31:0]                   ex_pc4       ,
    output reg [31:0]                   ex_A         ,
    output reg [31:0]                   ex_B         ,
    output reg [4:0]                    ex_wR        ,
    output reg [`NPC_SEL_WIDTH-1:0]     ex_npc_op
    
    //trace
//    ,input  wire [31:0] pc_i       ,
//    output reg  [31:0] pc_o       ,
//    input  wire        have_inst_i,
//    output reg         have_inst_o
    );

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ex_A        <= 0;
    end else if(Forward_A_en) begin
        ex_A <= A_forward;
    end else begin
        ex_A        <= id_A;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ex_B        <= 0;
        ex_rD2      <= 0;
    end else if(Forward_B_en) begin
        if(id_ram_we) begin
            ex_B <= id_B;
        end else begin
            ex_B <= B_forward;
        end
        ex_rD2 <= B_forward;
    end else begin
        ex_B        <= id_B;
        ex_rD2      <= id_rD2     ;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ex_alu_op   <= 0;
        ex_rf_we    <= 0;
        ex_ram_we   <= 0;
        ex_rf_wsel  <= 0;
        ex_dram_sel <= 0;
        
        ex_sext     <= 0;
        ex_pc4      <= 0;
        ex_wR       <= 0;
        ex_npc_op   <= 0;
    end else if(flush) begin
        ex_alu_op   <= 0;
        ex_rf_we    <= 0;
        ex_ram_we   <= 0;
        ex_rf_wsel  <= 0;
        ex_dram_sel <= 0;
        ex_sext     <= 0;
        ex_pc4      <= 0;
        ex_wR       <= 0;
        ex_npc_op   <= 0;
    end else begin
        ex_alu_op   <= id_alu_op  ;
        ex_rf_we    <= id_rf_we   ;
        ex_ram_we   <= id_ram_we  ;
        ex_rf_wsel  <= id_rf_wsel ;
        ex_dram_sel <= id_dram_sel;
        ex_sext     <= id_sext    ;
        ex_pc4      <= id_pc4     ;
        ex_wR       <= id_wR      ;
        ex_npc_op   <= id_npc_op  ;
    end
end

//trace
//always @ (posedge clk or posedge rst) begin
//    if (rst) pc_o <= 32'b0;
//    else if (flush) pc_o <= 32'b0;
//    else        pc_o <= pc_i;
//end
//always @ (posedge clk or posedge rst) begin
//    if (rst) have_inst_o <= 1'b0;
//    else if(flush)  have_inst_o <= 1'b0;
//    else        have_inst_o <= have_inst_i;
//end

endmodule
