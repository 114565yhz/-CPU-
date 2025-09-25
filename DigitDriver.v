`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/06 15:40:07
// Design Name: 
// Module Name: DigitDriver
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


module DigitDriver(
    input clk,
    input rst,
    input IOEn,
    input [11:0] IOAddr,
    input [31:0] IOWriteData,
    output reg [7:0]  led_en,
	output reg        led_ca,
	output reg        led_cb,
    output reg        led_cc,
	output reg        led_cd,
	output reg        led_ce,
	output reg        led_cf,
	output reg        led_cg,
	output wire       led_dp
    );
    
reg [3:0] hex;
reg [31:0] data;
reg [17:0] cnt;
parameter CNT = 20000;
wire en;
//assign en = IOEn && (IOAddr == `PERI_ADDR_DIG);
assign en = IOEn && (IOAddr == `DIGIT);

always @ (posedge clk or posedge rst) begin
    if (rst==`RstEnable) begin 
        data <= 0;
    end else if (en) begin
        data <= IOWriteData;
    end else begin
        data <= data;
    end
end

assign led_dp = 1;

always @(posedge clk or posedge rst) begin
    if(rst==`RstEnable) begin
        cnt = 0;
    end else begin
        if(cnt == CNT) begin
            cnt = 0;
        end else begin
            cnt = cnt+1;
        end
    end
end

always @ (posedge clk or posedge rst) begin
    if (rst==`RstEnable) begin 
        led_en <= 8'b1111_1110;
    end
    else if (cnt == CNT) begin
        led_en <= {led_en[0], led_en[7:1]};
    end
    else begin
        led_en <= led_en;
    end
end

always @ (*) begin
	case (led_en)
		8'b0111_1111: hex = data[31:28];
		8'b1011_1111: hex = data[27:24];
		8'b1101_1111: hex = data[23:20];
		8'b1110_1111: hex = data[19:16];
		8'b1111_0111: hex = data[15:12];
		8'b1111_1011: hex = data[11:8 ];
	    8'b1111_1101: hex = data[7 :4 ];
	    8'b1111_1110: hex = data[3 :0 ];
	    default     : hex = 4'h0       ;
	endcase
end

// 七段数码管如何表示 hex 的方法 1
always @ (*) begin
	case (hex)
		4'h0: begin
			// 只有 g 不亮
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 1;
		end
		4'h1: begin
			// 只有 b c 亮
            led_ca = 1;
			led_cb = 0;
			led_cc = 0;
			led_cd = 1;
			led_ce = 1;
			led_cf = 1;
			led_cg = 1;
		end
		4'h2: begin
			// 只有 c f 不亮
			led_ca = 0;
			led_cb = 0;
			led_cc = 1;
			led_cd = 0;
			led_ce = 0;
			led_cf = 1;
			led_cg = 0;
		end
		4'h3: begin
			// 只有 e f 不亮
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 0;
			led_ce = 1;
			led_cf = 1;
			led_cg = 0;
		end
		4'h4: begin
			led_ca = 1;
			led_cb = 0;
			led_cc = 0;
			led_cd = 1;
			led_ce = 1;
			led_cf = 0;
			led_cg = 0;
		end
		4'h5: begin
			// 只有 b e 不亮
			led_ca = 0;
			led_cb = 1;
			led_cc = 0;
			led_cd = 0;
			led_ce = 1;
			led_cf = 0;
			led_cg = 0;
		end
		4'h6: begin
			// 只有 b 不亮
			led_ca = 0;
			led_cb = 1;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		4'h7: begin
			// 只有 a b c 亮
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 1;
			led_ce = 1;
			led_cf = 1;
			led_cg = 1;
		end
		4'h8: begin
			// 全都亮
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		4'h9: begin
			// 只有 d e 不亮
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 1;
			led_ce = 1;
			led_cf = 0;
			led_cg = 0;
		end
		4'ha: begin
		    // 只有 d 不亮
		    led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 1;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		4'hb: begin
		    // 只有 a b 不亮
		    led_ca = 1;
			led_cb = 1;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		4'hc: begin
		    // 只有 d e g 亮
		    led_ca = 1;
			led_cb = 1;
			led_cc = 1;
			led_cd = 0;
			led_ce = 0;
			led_cf = 1;
			led_cg = 0;
		end
		4'hd: begin
		    // 只有 a f 不亮
		    led_ca = 1;
			led_cb = 0;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 1;
			led_cg = 0;
		end
		4'he: begin
		    // 只有 b c 不亮
		    led_ca = 0;
			led_cb = 1;
			led_cc = 1;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		4'hf: begin
		    // 只有 b c d 不亮
		    led_ca = 0;
			led_cb = 1;
			led_cc = 1;
			led_cd = 1;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		default: begin
			// 默认为 8
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
	endcase
end

endmodule
