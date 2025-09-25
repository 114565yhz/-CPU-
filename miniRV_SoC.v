`timescale 1ns / 1ps

`include "defines.vh"

module miniRV_SoC (
    input  wire         fpga_rst,   // High active
    input  wire         fpga_clk,

    input  wire [23:0]  switch,
    input  wire [ 4:0]  button,
    output wire [ 7:0]  dig_en,
    output wire         DN_A,
    output wire         DN_B,
    output wire         DN_C,
    output wire         DN_D,
    output wire         DN_E,
    output wire         DN_F,
    output wire         DN_G,
    output wire         DN_DP,
    output wire [23:0]  led

//`ifdef RUN_TRACE
//    ,// Debug Interface
//    output wire         debug_wb_have_inst, // 当前时钟周期是否有指令写回 (对单周期CPU，可在复位后恒置1)
//    output wire [31:0]  debug_wb_pc,        // 当前写回的指令的PC (若wb_have_inst=0，此项可为任意值)
//    output              debug_wb_ena,       // 指令写回时，寄存器堆的写使能 (若wb_have_inst=0，此项可为任意值)
//    output wire [ 4:0]  debug_wb_reg,       // 指令写回时，写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
//    output wire [31:0]  debug_wb_value      // 指令写回时，写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
//`endif
);

    wire        pll_lock;
    wire        pll_clk;
    wire        cpu_clk;

    // Interface between CPU and IROM
//`ifdef RUN_TRACE
//    wire [15:0] inst_addr;
//`else
    wire [13:0] inst_addr;
//`endif
    wire [31:0] inst;

    // Interface between CPU and Bridge
    wire [31:0] Bus_rdata;
    wire [31:0] Bus_addr;
    wire        Bus_wen;
    wire [31:0] Bus_wdata;
    
    // Interface between bridge and DRAM
    wire         rst_bridge2dram;
    wire         clk_bridge2dram;
    wire [31:0]  addr_bridge2dram;
    wire [31:0]  rdata_dram2bridge;
    wire         wen_bridge2dram;
    wire [31:0]  wdata_bridge2dram;
    
    // Interface between bridge and peripherals
    // TODO: 在此定义总线桥与外设I/O接口电路模块的连接信号
    wire [31:0] IOWriteData;
    wire [11:0] IOAddr;
    wire [31:0] IORead;
    wire        wen_to_led;
    wire        wen_to_dig;
    wire [31:0] wdata_to_led;
    
    
    
//`ifdef RUN_TRACE
//    // Trace调试时，直接使用外部输入时钟
//    assign cpu_clk = fpga_clk;
//`else
    // 下板时，使用PLL分频后的时钟
    assign cpu_clk = pll_clk & pll_lock;
    cpuclk Clkgen (
        // .resetn     (!fpga_rst),
        .clk_in1    (fpga_clk),
        .clk_out1   (pll_clk),
        .locked     (pll_lock)
    );
//`endif
    
    myCPU Core_cpu (
        .cpu_rst            (fpga_rst),
        .cpu_clk            (cpu_clk),

        // Interface to IROM
        
        //trace
//        .inst_addr          (inst_addr[15:2]),
        .inst_addr          (inst_addr),
        .inst               (inst),

        // Interface to Bridge
        .Bus_addr           (Bus_addr),
        .Bus_rdata          (Bus_rdata),
        .Bus_wen            (Bus_wen),
        .Bus_wdata          (Bus_wdata)

//`ifdef RUN_TRACE
//        ,// Debug Interface
//        .debug_wb_have_inst (debug_wb_have_inst),
//        .debug_wb_pc        (debug_wb_pc),
//        .debug_wb_ena       (debug_wb_ena),
//        .debug_wb_reg       (debug_wb_reg),
//        .debug_wb_value     (debug_wb_value)
//`endif
    );
    
    IROM Mem_IROM (
        //trace
//        .a          (inst_addr[15:2]),
        .a          (inst_addr),
        .spo        (inst)
    );
    
    Bridge Bridge (       
        // Interface to CPU
        .rst_from_cpu       (fpga_rst),
        .clk_from_cpu       (cpu_clk),
        .addr_from_cpu      (Bus_addr),
        .wen_from_cpu       (Bus_wen),
        .wdata_from_cpu     (Bus_wdata),
        .rdata_to_cpu       (Bus_rdata),
        
//         Interface to DRAM
//         .rst_to_dram    (rst_bridge2dram),
        .clk_to_dram        (clk_bridge2dram),
        .addr_to_dram       (addr_bridge2dram),
        .rdata_from_dram    (rdata_dram2bridge),
        .wen_to_dram        (wen_bridge2dram),
        .wdata_to_dram      (wdata_bridge2dram),
        
//         Interface to 7-seg digital LEDs
        .rst_to_dig         (fpga_rst),
        .clk_to_dig         (cpu_clk),
        .addr_to_dig        (IOAddr),
        .wen_to_dig         (wen_to_dig),
        .wdata_to_dig       (IOWriteData),

//         Interface to LEDs
        .rst_to_led         (fpga_rst),
        .clk_to_led         (cpu_clk),
        .addr_to_led        (IOAddr),
        .wen_to_led         (wen_to_led),
        .wdata_to_led       (IOWriteData),

//         Interface to switches
        .rst_to_sw          (fpga_rst),
        .clk_to_sw          (cpu_clk),
        .addr_to_sw         (IOAddr),
        .rdata_from_sw      (IORead),

        // Interface to buttons
        .rst_to_btn         (/* TODO */),
        .clk_to_btn         (/* TODO */),
        .addr_to_btn        (/* TODO */),
        .rdata_from_btn     (/* TODO */)
    );
//    DRAM Mem_DRAM (
//        .clk        (cpu_clk),
//        .a          (Bus_addr[15:2]),
//        .spo        (Bus_rdata),
//        .we         (Bus_wen),
//        .d          (Bus_wdata)
//    );
    DRAM Mem_DRAM (
        .clk        (clk_bridge2dram),
        .a          (addr_bridge2dram[15:2]),
        .spo        (rdata_dram2bridge),
        .we         (wen_bridge2dram),
        .d          (wdata_bridge2dram)
    );
    
   
//     TODO: 在此实例化你的外设I/O接口电路模块
    DigitDriver U_DigitDriver(
        .clk(cpu_clk),
        .rst(fpga_rst),
        .IOEn(wen_to_dig),
        .IOAddr(IOAddr),
        .IOWriteData(IOWriteData),
        .led_en(dig_en),
        .led_ca(DN_A),
        .led_cb(DN_B),
        .led_cc(DN_C),
        .led_cd(DN_D),
        .led_ce(DN_E),
        .led_cf(DN_F),
        .led_cg(DN_G),
        .led_dp(DN_DP)
    );
    
    LEDDriver U_LEDDriver(
        .clk          (cpu_clk),
        .rst          (fpga_rst),
        .IOEn         (wen_to_led),
        .IOAddr       (IOAddr),
        .IOWriteData  (IOWriteData),
        .led          (led)
    );
    
    SwitchDriver U_SwitchDriver(
        .clk(cpu_clk),
        .rst(fpga_rst),
        .IOAddr   (IOAddr),
        .switch   (switch),
        .IORead   (IORead)
    );
endmodule
