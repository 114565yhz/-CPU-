`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/12 23:10:23
// Design Name: 
// Module Name: MEM_wD_MUX
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


module MEM_wD_MUX(
    input  wire [`RF_WSEL_WIDTH-1:0] rf_wsel,
    input  wire [31:0] DRAM_rdo,
    input  wire [31:0] wD_temp,
    output reg  [31:0] wD
    );
    
always @ (*) begin
    if (rf_wsel == `RF_WSEL_DRAM) begin
        wD = DRAM_rdo;
    end else begin
        wD = wD_temp;
    end
end

endmodule
