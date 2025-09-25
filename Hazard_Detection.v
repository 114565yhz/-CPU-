`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/11 10:21:58
// Design Name: 
// Module Name: Hazard_Detection
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
module Hazard_Detection(
    input                       id_rf1_used  , 
    input                       id_rf2_used  , 
    input [`RF_WSEL_WIDTH-1:0]  ex_rf_wsel   , 
    input [4:0]                 ex_wR        , 
    input [4:0]                 mem_wR       , 
    input [4:0]                 wb_wR        , 
    input [31:0]                ex_wD        , 
    input [31:0]                mem_wD       , 
    input [31:0]                wb_wD        , 
    input [31:0]                id_rR1       ,
    input [31:0]                id_rR2       ,
    input                       branched     , 
    input                       ex_rf_we     ,
    input                       mem_rf_we    ,
    input                       wb_rf_we     ,
    output reg                  stall        , 
    output reg                  flush_IF_ID  , 
    output reg                  flush_ID_EX  , 
    output reg [31:0]           A_forward    , 
    output reg [31:0]           B_forward    , 
    output wire                 Forward_A_en , 
    output wire                 Forward_B_en  
);


wire RAW_A_rD1 = (ex_wR  == id_rR1) && ex_rf_we  && id_rf1_used && ~(ex_wR==0);
wire RAW_A_rD2 = (ex_wR  == id_rR2) && ex_rf_we  && id_rf2_used && ~(ex_wR==0);


wire RAW_B_rD1 = (mem_wR == id_rR1) && mem_rf_we && id_rf1_used && ~(mem_wR==0);
wire RAW_B_rD2 = (mem_wR == id_rR2) && mem_rf_we && id_rf2_used && ~(mem_wR==0);


wire RAW_C_rD1 = (wb_wR  == id_rR1) && wb_rf_we  && id_rf1_used && ~(wb_wR==0);
wire RAW_C_rD2 = (wb_wR  == id_rR2) && wb_rf_we  && id_rf2_used && ~(wb_wR==0);

assign Forward_A_en = RAW_A_rD1 || RAW_B_rD1 || RAW_C_rD1;
assign Forward_B_en = RAW_A_rD2 || RAW_B_rD2 || RAW_C_rD2;


always @ (*) begin
    if (RAW_A_rD1)      A_forward = ex_wD;
    else if (RAW_B_rD1) A_forward = mem_wD;
    else if (RAW_C_rD1) A_forward = wb_wD;
    else                A_forward = 32'b0;
end

always @ (*) begin
    if (RAW_A_rD2)      B_forward = ex_wD; 
    else if (RAW_B_rD2) B_forward = mem_wD;
    else if (RAW_C_rD2) B_forward = wb_wD; 
    else                B_forward = 32'b0; 
end

wire load_use_exist = (RAW_A_rD1 || RAW_A_rD2) & (ex_rf_wsel == `RF_WSEL_DRAM);

always @ (*) begin
    if (load_use_exist) stall = 1'b1;
    else                 stall = 1'b0;
end

always @ (*) begin
    if (branched) flush_IF_ID = 1'b1;
    else          flush_IF_ID = 1'b0;
end

always @ (*) begin
    if (load_use_exist || branched) flush_ID_EX = 1'b1;
    else                            flush_ID_EX = 1'b0;
end
endmodule
/*
module Hazard_Detection(
    input id_rf1_used,
    input id_rf2_used,
    input [31:0] ex_mem_wD,
    input [31:0] mem_wb_wD,
    input [4:0] if_id_RegisterRs1,
    input [4:0] if_id_RegisterRs2,
    input [4:0] id_ex_RegisterRs1,
    input [4:0] id_ex_RegisterRs2,
    input ex_mem_RegWrite,
    input [4:0] ex_mem_RegisterRd,
    input mem_wb_RegWrite,
    input [4:0] mem_wb_RegisterRd,
    input id_ex_MemRead,
    input branched,
    output reg Forward_A_en,
    output reg Forward_B_en,
    output reg [31:0] A_forward,
    output reg [31:0] B_forward,
    output reg stall,
    output reg flush_if_id,
    output reg flush_id_ex
    );

//reg [31:0] ex_mem_wD;
//reg [31:0] ex_mem_wD;
//always @(*) begin
    
//end



always @(*) begin
    if(id_rf1_used && ex_mem_RegWrite && ~(ex_mem_RegisterRd==0) && (ex_mem_RegisterRd==id_ex_RegisterRs1)) begin
        Forward_A_en = 1;
        A_forward = ex_mem_wD;
    end else begin
        Forward_A_en = 0;
        A_forward = 32'hFFFFFFFF;
    end
end

always @(*) begin
    if(id_rf2_used && ex_mem_RegWrite && ~(ex_mem_RegisterRd==0) && (ex_mem_RegisterRd==id_ex_RegisterRs2)) begin
        Forward_B_en = 1;
        B_forward = ex_mem_wD;
    end else begin
        Forward_B_en = 0;
        B_forward = 32'hFFFFFFFF;
    end
end


always @(*) begin
    if(id_rf1_used && mem_wb_RegWrite && ~(mem_wb_RegisterRd==0) && ~(ex_mem_RegWrite && ~(ex_mem_RegisterRd==0) && (ex_mem_RegisterRd==id_ex_RegisterRs1)) && (mem_wb_RegisterRd==id_ex_RegisterRs1)) begin
        Forward_A_en = 1;
        A_forward = mem_wb_wD;
    end else begin
        Forward_A_en = 0;
        A_forward = 32'hFFFFFFFF;
    end
end

always @(*) begin
    if(id_rf2_used && mem_wb_RegWrite && ~(mem_wb_RegisterRd==0) && ~(ex_mem_RegWrite && ~(ex_mem_RegisterRd==0) && (ex_mem_RegisterRd==id_ex_RegisterRs2)) && (mem_wb_RegisterRd==id_ex_RegisterRs1)) begin
        Forward_B_en = 1;
        B_forward = mem_wb_wD;
    end else begin
        Forward_B_en = 0;
        B_forward = 32'hFFFFFFFF;
    end
end


wire load_use_exist = id_ex_MemRead && ((id_ex_RegisterRs1==if_id_RegisterRs1) || (id_ex_RegisterRs2==if_id_RegisterRs2));

always @(*) begin
    if(load_use_exist) begin
        stall = 1;
    end else begin
        stall = 0;
    end
end

always @(*) begin
    if(branched) begin
        flush_if_id = 1;
    end else begin
        flush_if_id = 0;
    end
end

always @(*) begin
    if(load_use_exist || branched) begin
        flush_id_ex = 1;
    end else begin
        flush_id_ex = 0;
    end
end

endmodule*/
