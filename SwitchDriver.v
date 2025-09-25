`timescale 1ns / 1ps
module SwitchDriver (
    input  wire        clk,
	input  wire        rst,
    input  wire [11:0] IOAddr    ,
    input  wire [23:0] switch    ,
	output wire [31:0] IORead
);

wire en;
assign en = (IOAddr == `SWITCH);

assign IORead =  en ? {8'b0, switch} : 32'h0000_0000;

endmodule
