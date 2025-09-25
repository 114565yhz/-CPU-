`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/06 16:00:59
// Design Name: 
// Module Name: LEDDriver
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


module LEDDriver(
    input  wire        clk,
	input  wire        rst,
    input  wire        IOEn,
    input  wire [11:0] IOAddr,
    input  wire [31:0] IOWriteData,
	output reg  [23:0] led
    );
    
wire en;
//assign en = IOEn && (IOAddr == `PERI_ADDR_LED);
assign en = IOEn && (IOAddr == `LED);

always @ (posedge clk or posedge rst) begin
    if (rst) begin 
        led <= 0;
    end else if (en) begin 
        led <= IOWriteData[23:0];
    end else begin
        led <= led;
    end    
end

endmodule
