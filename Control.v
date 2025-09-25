`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 15:50:54
// Design Name: 
// Module Name: Control
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

module Control(
    input wire [6:0]                    opcode       ,
    input wire [2:0]                    funct3       ,
    input wire [6:0]                    funct7       ,
    output reg [`Sext_OP_WDITH-1:0]     sext_op      ,
    output reg [`NPC_SEL_WIDTH-1:0]     npc_op       ,
    output reg [`ALU_OP_WIDTH-1:0]      alu_op       ,
    output reg [`ALUA_SEL_WIDTH-1:0]    alua_sel     ,
    output reg [`ALUB_SEL_WIDTH-1:0]    alub_sel     ,
    output reg [`RF_WSEL_WIDTH-1:0]     rf_wsel      ,
    output reg [`DRAM_SEL_WIDTH-1:0]    dram_sel     ,
    output reg                          rf_we        ,
    output reg                          ram_we       ,
    output wire                         id_rf1_used  ,
    output wire                         id_rf2_used
    
//    ,//trace
//    output reg have_inst
    );
//    always @ (*) begin
//        case (opcode)
//            `OPCODE_R, `OPCODE_I_REG, `OPCODE_I_LOAD, `OPCODE_JALR, `OPCODE_S, `OPCODE_B, `OPCODE_LUI, `OPCODE_AUIPC ,`OPCODE_JAL:
//                have_inst = 1'b1;
//            default:
//                have_inst = 1'b0;
//        endcase
//    end


assign id_rf1_used = ~((opcode == `OPCODE_LUI) || (opcode == `OPCODE_JAL));
assign id_rf2_used = ((opcode == `OPCODE_R) || (opcode == `OPCODE_S) || (opcode == `OPCODE_B));

always @(*) begin
    case (opcode) 
        `OPCODE_R: begin
            npc_op = `NPC_SEL_NEXT;
            alua_sel = `ALUA_SEL_RD1;
            alub_sel = `ALUB_SEL_RD2;
            rf_wsel = `RF_WSEL_ALUC;
            rf_we = 1;
            ram_we = 0;
            case (funct3)
                `FUNCT3_ADD_SUB: begin
                    case (funct7[5]) 
                        1'b0: alu_op = `ALU_ADD;
                        1'b1: alu_op = `ALU_SUB;
                    endcase
                end
                `FUNCT3_AND: begin
                    alu_op = `ALU_AND;
                end
                `FUNCT3_OR: begin
                    alu_op = `ALU_OR;
                end
                `FUNCT3_XOR: begin
                    alu_op = `ALU_XOR;
                end
                `FUNCT3_SLL: begin
                    alu_op = `ALU_SLL;
                end
                `FUNCT3_SHIFT_RIGHT: begin
                     case (funct7[5]) 
                        1'b0: alu_op = `ALU_SRL;
                        1'b1: alu_op = `ALU_SRA;
                    endcase
                end
                `FUNCT3_SLT: begin
                    alu_op = `ALU_SLT;
                end
                `FUNCT3_SLTU: begin
                    alu_op = `ALU_SLTU;
                end
                default begin
                end
            endcase 
        end
        `OPCODE_I_REG: begin
            sext_op = `Sext_I;
            npc_op = `NPC_SEL_NEXT;
            alua_sel = `ALUA_SEL_RD1;
            alub_sel = `ALUB_SEL_SEXT;
            rf_wsel = `RF_WSEL_ALUC;
            rf_we = 1;
            ram_we = 0;
            case (funct3)
                `FUNCT3_ADDI: begin
                    alu_op = `ALU_ADD;
                end
                `FUNCT3_ANDI: begin
                    alu_op = `ALU_AND;
                end
                `FUNCT3_ORI: begin
                    alu_op = `ALU_OR;
                end
                `FUNCT3_XORI: begin
                    alu_op = `ALU_XOR;
                end
                `FUNCT3_SLLI: begin
                    alu_op = `ALU_SLL;
                end
                `FUNCT3_SHIFT_RIGHT: begin
                    case (funct7[5]) 
                        1'b0: alu_op = `ALU_SRL;
                        1'b1: alu_op = `ALU_SRA;
                    endcase
                end
                `FUNCT3_SLTI: begin
                    alu_op = `ALU_SLT;
                end
                `FUNCT3_SLTIU: begin
                    alu_op = `ALU_SLTU;
                end
            endcase
        end
        `OPCODE_I_LOAD: begin
            sext_op = `Sext_I;
            npc_op = `NPC_SEL_NEXT;
            alua_sel = `ALUA_SEL_RD1;
            alub_sel = `ALUB_SEL_SEXT;
            rf_wsel = `RF_WSEL_DRAM;
            rf_we = 1;
            ram_we = 0;
            alu_op = `ALU_ADD;
            case (funct3)
                `FUNCT3_LB: dram_sel = `DRAM_SEL_LB;
                `FUNCT3_LBU: dram_sel = `DRAM_SEL_LBU;
                `FUNCT3_LH: dram_sel = `DRAM_SEL_LH;
                `FUNCT3_LHU: dram_sel = `DRAM_SEL_LHU;
                `FUNCT3_LW: dram_sel = `DRAM_SEL_LW;
                default: dram_sel = 0;
            endcase
        end
        `OPCODE_JALR: begin
            sext_op = `Sext_I;
            npc_op = `NPC_SEL_ALU;
            alua_sel = `ALUA_SEL_RD1;
            alub_sel = `ALUB_SEL_SEXT;
            rf_wsel = `RF_WSEL_PC4;
            rf_we = 1;
            ram_we = 0;
            alu_op = `ALU_ADD;
        end
        `OPCODE_S: begin
            sext_op = `Sext_S;
            npc_op = `NPC_SEL_NEXT;
            alua_sel = `ALUA_SEL_RD1;
            alub_sel = `ALUB_SEL_SEXT;
            rf_we = 0;
            ram_we = 1;
            alu_op = `ALU_ADD;
            case (funct3)
                `FUNCT3_SB: dram_sel = `DRAM_SEL_SB;
                `FUNCT3_SH: dram_sel = `DRAM_SEL_SH;
                `FUNCT3_SW: dram_sel = `DRAM_SEL_SW;
                default: dram_sel = 0;
            endcase
        end
        `OPCODE_B: begin
            sext_op = `Sext_B;
            alua_sel = `ALUA_SEL_RD1;
            alub_sel = `ALUB_SEL_RD2;
            npc_op = `NPC_SEL_BRANCH;
            rf_we = 0;
            ram_we = 0;
            case (funct3)
                `FUNCT3_BEQ: begin
                    alu_op = `ALU_BEQ;
                end
                `FUNCT3_BNE: begin
                    alu_op = `ALU_BNE;
                end
                `FUNCT3_BLT: begin
                    alu_op = `ALU_BLT;
                end
                `FUNCT3_BLTU: begin
                    alu_op = `ALU_BLTU;
                end
                `FUNCT3_BGE: begin
                    alu_op = `ALU_BGE;
                end
                `FUNCT3_BGEU: begin
                    alu_op = `ALU_BGEU;
                end
                default: begin
                    alu_op = 0;
                end
            endcase
        end
        `OPCODE_LUI: begin
            //不需要用到ALU，DRAM
            sext_op = `Sext_U;
            npc_op = `NPC_SEL_NEXT;
            rf_wsel = `RF_WSEL_SEXT;
            rf_we = 1;
            ram_we = 0;
        end
        `OPCODE_AUIPC: begin
            sext_op = `Sext_U;
            npc_op = `NPC_SEL_NEXT;
            alua_sel = `ALUA_SEL_PC;
            alub_sel = `ALUB_SEL_SEXT;
            alu_op = `ALU_ADD;
            rf_wsel = `RF_WSEL_ALUC;
            rf_we = 1;
            ram_we = 0;
        end
        `OPCODE_JAL: begin
            //不需要经过ALU
            sext_op = `Sext_J;
            npc_op = `NPC_SEL_JAL;
            rf_wsel = `RF_WSEL_PC4;
            rf_we = 1;
            ram_we = 0;
        end
        default: begin
            sext_op      = 0;
            npc_op       = 0;
            alu_op       = 0;
            alua_sel     = 0;
            alub_sel     = 0;
            rf_wsel      = 0;
            dram_sel     = 0;
            rf_we        = 0;
            ram_we       = 0;
        end
    endcase
end

endmodule
