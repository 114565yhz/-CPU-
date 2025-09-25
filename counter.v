`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/07 15:50:24
// Design Name: 
// Module Name: counter
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


module counter #(
    parameter END=15,
    parameter WIDTH=4
)(
    input clk, 
    input rst, 
    input cnt_inc, 
    output cnt_end, 
    output reg[WIDTH-1:0] cnt
);

assign cnt_end = (cnt == END);

always @(posedge clk, posedge rst) begin
	if (rst) cnt <= 0;
	else if (cnt_end) cnt <= 0;
	else if (cnt_inc) cnt <= cnt + 1;
end

endmodule
