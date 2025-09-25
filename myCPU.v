`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
    output wire [13:0]  inst_addr,
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_wen,
    output wire [31:0]  Bus_wdata

//`ifdef RUN_TRACE
//    ,// Debug Interface
//    output wire         debug_wb_have_inst,
//    output wire [31:0]  debug_wb_pc,
//    output               debug_wb_ena,
//    output wire [ 4:0]  debug_wb_reg,
//    output wire [31:0]  debug_wb_value
//`endif
);
//trace
wire [31:0] pc_EX, pc_MEM, pc_WB;
wire        have_inst_ID, have_inst_EX, have_inst_MEM, have_inst_WB;


wire [31:0] if_npc;
wire [31:0] if_pc;
wire [31:0] id_pc;
wire [31:0] wb_pc;
wire [31:0] if_pc4;
wire [31:0] id_pc4;
wire [31:0] ex_pc4;

//wire [31:0] pc4;
wire [31:0] id_sext;
wire [31:0] ex_sext;
wire [31:0] mem_sext;
wire [31:0] wb_sext;
wire [`Sext_OP_WDITH-1:0] id_sext_op;
wire ex_alu_f;
wire [31:0] ex_alu_c;
wire [31:0] mem_alu_c;
wire [31:0] wb_alu_c;
wire [`NPC_SEL_WIDTH-1:0] id_npc_op;
wire [`NPC_SEL_WIDTH-1:0] ex_npc_op;
wire [`ALU_OP_WIDTH-1:0] id_alu_op;
wire [`ALU_OP_WIDTH-1:0] ex_alu_op;
wire [`ALUA_SEL_WIDTH-1:0] id_alua_sel;
wire [`ALUB_SEL_WIDTH-1:0] id_alub_sel;
wire [`RF_WSEL_WIDTH-1:0] id_rf_wsel;
wire [`RF_WSEL_WIDTH-1:0] ex_rf_wsel;
wire [`RF_WSEL_WIDTH-1:0] mem_rf_wsel;
wire [`RF_WSEL_WIDTH-1:0] wb_rf_wsel;
wire [`DRAM_SEL_WIDTH-1:0] id_dram_sel;
wire [`DRAM_SEL_WIDTH-1:0] ex_dram_sel;
wire [`DRAM_SEL_WIDTH-1:0] mem_dram_sel;
wire id_rf_we;
wire ex_rf_we;
wire mem_rf_we;
wire wb_rf_we;
wire id_ram_we;
wire ex_ram_we;
wire mem_ram_we;
wire [31:0] id_rD1;
wire [31:0] id_rD2;
wire [31:0] ex_rD2;
wire [31:0] mem_rD2;
wire [31:0] id_A;
wire [31:0] id_B;
wire [31:0] ex_A;
wire [31:0] ex_B;
wire [31:0] mem_DRAM_rdo;
wire [31:0] wb_DRAM_rdo;
wire [4:0] ex_wR;
wire [4:0] mem_wR;
wire [4:0] wb_wR;
wire [31:0] ex_wD;
wire [31:0] mem_wD;
wire [31:0] wb_wD;
wire [31:0] mem_wD_temp;

assign inst_addr = if_pc[15:2];
//assign Bus_wen = ram_we;
//assign Bus_wdata = rD2;
//assign Bus_addr = alu_c;

wire stall;
wire flush_if_id;
wire flush_id_ex;

wire id_rf1_used;
wire id_rf2_used;

wire branched;
// TODO: 完成你自己的单周期CPU设计
NPC U_NPC(
    .rst(cpu_rst),
    .PC(if_pc),
    .offset(ex_sext),
    .br(ex_alu_f),
    .npc_op(ex_npc_op),
    .alu_c(ex_alu_c),
    .npc(if_npc),
    .pc4(if_pc4),
    .branched(branched)
);

PC U_PC(
    .clk(cpu_clk),
    .rst(cpu_rst),
    .stall(stall),
    .din(if_npc),
    .pc(if_pc)
);

wire [31:0] if_inst = inst;
wire [31:0] id_inst;

IF_ID U_IF_ID(
    .clk      (cpu_clk),
    .rst      (cpu_rst),
    .stall    (stall),
    .flush    (flush_if_id),
    .if_pc    (if_pc),
    .if_pc4   (if_pc4),
    .if_inst  (if_inst),
    .id_pc    (id_pc),
    .id_pc4   (id_pc4),
    .id_inst  (id_inst)
);
    
SEXT U_SEXT(
    .din(id_inst[31:7]),
    .sext_op(id_sext_op),
    .sext(id_sext)
);

Control U_Control(
    .opcode(id_inst[6:0]),
    .funct3(id_inst[14:12]),
    .funct7(id_inst[31:25]),
    .sext_op(id_sext_op),
    .npc_op(id_npc_op),
    .alu_op(id_alu_op),
    .alua_sel(id_alua_sel),
    .alub_sel(id_alub_sel),
    .rf_wsel(id_rf_wsel),
    .dram_sel(id_dram_sel),
    .rf_we(id_rf_we),
    .ram_we(id_ram_we),
    .id_rf1_used(id_rf1_used),
    .id_rf2_used(id_rf2_used)
    
//    ,//trace
//    .have_inst(have_inst_ID)
);

RegFile U_RegFile(
    .rst(cpu_rst),
    .clk(cpu_clk),
    .rR1(id_inst[19:15]),
    .rR2(id_inst[24:20]),
    .wR(wb_wR),
    .we(wb_rf_we),
    .wD(wb_wD),
    .rD1(id_rD1),
    .rD2(id_rD2)
);

ALU_input_MUX U_ALU_input_MUX(
    .rD1(id_rD1),
    .rD2(id_rD2),
    .pc(id_pc),
    .sext(id_sext),
    .alua_sel(id_alua_sel),
    .alub_sel(id_alub_sel),
    .A(id_A),
    .B(id_B)
);

wire [31:0] A_forward;
wire [31:0] B_forward;
wire Forward_A_en;
wire Forward_B_en;
ID_EX U_ID_EX(
    .clk           (cpu_clk),
    .rst           (cpu_rst),
    .flush         (flush_id_ex),
    .id_alu_op     (id_alu_op    ),
    .id_rf_we      (id_rf_we     ),
    .id_ram_we     (id_ram_we    ),
    .id_rf_wsel    (id_rf_wsel   ),
    .id_dram_sel   (id_dram_sel  ),
    .id_rD2        (id_rD2       ),
    .id_pc4        (id_pc4       ),
    .id_npc_op     (id_npc_op    ),
    .id_sext       (id_sext      ),
    .id_A          (id_A         ),
    .id_B          (id_B         ),
    .id_wR         (id_inst[11:7]),
    .Forward_A_en  (Forward_A_en ),
    .Forward_B_en  (Forward_B_en ),
    .A_forward     (A_forward    ),
    .B_forward     (B_forward    ),
    .ex_alu_op     (ex_alu_op    ),
    .ex_rf_we      (ex_rf_we     ),
    .ex_ram_we     (ex_ram_we    ),
    .ex_rf_wsel    (ex_rf_wsel   ),
    .ex_dram_sel   (ex_dram_sel  ),
    .ex_rD2        (ex_rD2       ),
    .ex_sext       (ex_sext      ),
    .ex_pc4        (ex_pc4       ),
    .ex_A          (ex_A         ),
    .ex_B          (ex_B         ),
    .ex_wR         (ex_wR        ),
    .ex_npc_op     (ex_npc_op    )
    

//    ,//trace
//    .pc_i        (id_pc         ),
//    .pc_o        (pc_EX         ),
//    .have_inst_i (have_inst_ID  ),
//    .have_inst_o (have_inst_EX  )
);

ALU U_ALU(
    .A(ex_A),
    .B(ex_B),
    .alu_op(ex_alu_op),
    .alu_c(ex_alu_c),
    .alu_f(ex_alu_f)
);

EX_wD_MUX U_EX_wD_MUX(
    .rf_wsel (ex_rf_wsel),
    .pc4     (ex_pc4), 
    .sext    (ex_sext), 
    .alu_c   (ex_alu_c), 
    .wD      (ex_wD)
);

EX_MEM U_EX_MEM(
    .clk            (cpu_clk),
    .rst            (cpu_rst),
    .ex_rf_we       (ex_rf_we    ),
    .ex_ram_we      (ex_ram_we   ),
    .ex_alu_c       (ex_alu_c    ),
    .ex_dram_sel    (ex_dram_sel ),
    .ex_rf_wsel     (ex_rf_wsel  ),
    .ex_rD2         (ex_rD2      ),
    .ex_wR          (ex_wR       ),
    .ex_wD          (ex_wD       ),
    .mem_rf_we      (mem_rf_we   ),
    .mem_ram_we     (mem_ram_we  ),
    .mem_alu_c      (mem_alu_c   ),
    .mem_rD2        (mem_rD2     ),
    .mem_dram_sel   (mem_dram_sel),
    .mem_rf_wsel    (mem_rf_wsel ),
    .mem_wR         (mem_wR      ),
    .mem_wD_temp    (mem_wD_temp )
    
    
//    ,//trace
//    .pc_i        (pc_EX        ),
//    .pc_o        (pc_MEM       ),
//    .have_inst_i (have_inst_EX ),
//    .have_inst_o (have_inst_MEM)
);

MEM U_MEM(
    .we_in(mem_ram_we),
    .addr_in(mem_alu_c),
    .wdin(mem_rD2),
    .dram_sel(mem_dram_sel),
    .DRAM_rdata_in(Bus_rdata),
    .addr_out(Bus_addr),
    .we_out(Bus_wen),
    .wdata_out(Bus_wdata),
    .rdo(mem_DRAM_rdo)
);

MEM_wD_MUX U_MEM_wD_MUX(
    .rf_wsel (mem_rf_wsel),
    .DRAM_rdo(mem_DRAM_rdo),
    .wD_temp (mem_wD_temp),
    .wD      (mem_wD)
);

MEM_WB U_MEM_WB(
    .clk             (cpu_clk),
    .rst             (cpu_rst),
    .mem_rf_we       (mem_rf_we),
    .mem_wR          (mem_wR),
    .mem_wD          (mem_wD),
    .wb_rf_we        (wb_rf_we),
    .wb_wR           (wb_wR),
    .wb_wD           (wb_wD)
    
//    ,//trace
//    .pc_i        (pc_MEM       ),
//    .pc_o        (pc_WB        ),
//    .have_inst_i (have_inst_MEM),
//    .have_inst_o (have_inst_WB )
);



//RegFile_wD_MUX U_RegFile_wD_MUX(
//    .rf_wsel(wb_rf_wsel),
//    .DRAM_rdo(wb_DRAM_rdo),
//    .alu_c(wb_alu_c),
//    .pc4(wb_pc4),
//    .sext(wb_sext),
//    .wD(wb_wD)
//);

Hazard_Detection U_Hazard_Detection(
    .id_rf1_used    (id_rf1_used ),
    .id_rf2_used    (id_rf2_used ),
    .ex_rf_wsel     (ex_rf_wsel  ),
    .ex_wR          (ex_wR       ),
    .mem_wR         (mem_wR      ),
    .wb_wR          (wb_wR       ),
    .ex_wD          (ex_wD       ),
    .mem_wD         (mem_wD      ),
    .wb_wD          (wb_wD       ),
    .id_rR1         (id_inst[19:15]),
    .id_rR2         (id_inst[24:20]),
    .branched       (branched    ),
    .ex_rf_we       (ex_rf_we    ),
    .mem_rf_we      (mem_rf_we   ),
    .wb_rf_we       (wb_rf_we    ),
    .stall          (stall       ),
    .flush_IF_ID    (flush_if_id ),
    .flush_ID_EX    (flush_id_ex ),
    .A_forward      (A_forward   ),
    .B_forward      (B_forward   ),
    .Forward_A_en   (Forward_A_en),
    .Forward_B_en   (Forward_B_en)
);
//`ifdef RUN_TRACE
//     Debug Interface
//    assign debug_wb_have_inst = have_inst_WB;
//    assign debug_wb_pc        = pc_WB;
//    assign debug_wb_ena       = wb_rf_we;
//    assign debug_wb_reg       = wb_wR;
//    assign debug_wb_value     = wb_wD;
//`endif

endmodule
