`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/05 21:34:38
// Design Name: 
// Module Name: MEM
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


module MEM(
//    input clk,
    input we_in,
    input [31:0] addr_in,
    input [31:0] wdin,
    input [`DRAM_SEL_WIDTH-1:0] dram_sel,
    input wire [31:0] DRAM_rdata_in,
    output wire [31:0] addr_out,
    output wire we_out,
    output reg [31:0] wdata_out,
    output reg [31:0] rdo
    );

assign we_out = we_in;
assign addr_out = addr_in;

always @(*) begin
    case (dram_sel) 
        `DRAM_SEL_LW: begin
            rdo = DRAM_rdata_in;
        end
        `DRAM_SEL_LB: begin
            case (addr_in[1:0]) 
                0: rdo = {{24{DRAM_rdata_in[7]}},DRAM_rdata_in[7:0]};
                1: rdo = {{24{DRAM_rdata_in[15]}},DRAM_rdata_in[15:8]};
                2: rdo = {{24{DRAM_rdata_in[23]}},DRAM_rdata_in[23:16]};
                3: rdo = {{24{DRAM_rdata_in[31]}},DRAM_rdata_in[31:24]};
                default: rdo = 0;
            endcase 
        end
        `DRAM_SEL_LBU: begin
            case (addr_in[1:0]) 
                0: rdo = {{24{1'b0}},DRAM_rdata_in[7:0]};
                1: rdo = {{24{1'b0}},DRAM_rdata_in[15:8]};
                2: rdo = {{24{1'b0}},DRAM_rdata_in[23:16]};
                3: rdo = {{24{1'b0}},DRAM_rdata_in[31:24]};
                default: rdo = 0;
            endcase 
        end
        `DRAM_SEL_LH: begin
            case (addr_in[1:0]) 
                0: rdo = {{16{DRAM_rdata_in[15]}},DRAM_rdata_in[15:0]};
                1: rdo = {{16{DRAM_rdata_in[23]}},DRAM_rdata_in[23:8]};
                2: rdo = {{16{DRAM_rdata_in[31]}},DRAM_rdata_in[31:16]};
                default: rdo = 0;
            endcase 
        end
        `DRAM_SEL_LHU: begin
            case (addr_in[1:0]) 
                0: rdo = {{16{1'b0}},DRAM_rdata_in[15:0]};
                1: rdo = {{16{1'b0}},DRAM_rdata_in[23:8]};
                2: rdo = {{16{1'b0}},DRAM_rdata_in[31:16]};
                default: rdo = 0;
            endcase 
        end
        `DRAM_SEL_SW: begin
            wdata_out = wdin;
        end
        `DRAM_SEL_SB: begin
            case (addr_in[1:0]) 
                0: begin 
                    wdata_out[31:8] = DRAM_rdata_in[31:8];
                    wdata_out[7:0] = wdin[7:0];
                end
                1: begin 
                    wdata_out[7:0] = DRAM_rdata_in[7:0];
                    wdata_out[31:16] = DRAM_rdata_in[31:16];
                    wdata_out[15:8] = wdin[7:0];
                end
                2: begin 
                    wdata_out[15:0] = DRAM_rdata_in[15:0];
                    wdata_out[31:24] = DRAM_rdata_in[31:24];
                    wdata_out[23:16] = wdin[7:0];
                end
                3: begin 
                    wdata_out[23:0] = DRAM_rdata_in[23:0];
                    wdata_out[31:24] = wdin[7:0];
                end
                default: wdata_out = 0;
            endcase 
        end
        `DRAM_SEL_SH: begin
            case (addr_in[1:0]) 
                0: begin 
                    wdata_out[31:16] = DRAM_rdata_in[31:16];
                    wdata_out[15:0] = wdin[15:0];
                end
                1: begin 
                    wdata_out[7:0] = DRAM_rdata_in[7:0];
                    wdata_out[31:24] = DRAM_rdata_in[31:24];
                    wdata_out[23:8] = wdin[15:0];
                end
                2: begin 
                    wdata_out[15:0] = DRAM_rdata_in[15:0];
                    wdata_out[31:16] = wdin[15:0];
                end
                default: wdata_out = 0;
            endcase 
        end
        default: begin
            wdata_out = wdin;
            rdo = 0;
        end
    endcase 
end
    
endmodule
