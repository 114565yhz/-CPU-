`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/12 23:10:23
// Design Name: 
// Module Name: EX_wD_MUX1
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


module EX_wD_MUX(
    input  wire [`RF_WSEL_WIDTH-1:0] rf_wsel,
    input  wire [31:0] pc4   ,
    input  wire [31:0] sext   ,
    input  wire [31:0] alu_c ,
    output reg  [31:0] wD
    );
    
always @ (*) begin
    case (rf_wsel)
        `RF_WSEL_SEXT: wD = sext;
        `RF_WSEL_ALUC: wD = alu_c;
        `RF_WSEL_PC4:  wD = pc4;
        default:   wD = 32'b0;
    endcase
end

endmodule
