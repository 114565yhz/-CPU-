# MiniRV Pipelined CPU

![Verilog](https://img.shields.io/badge/HDL-Verilog-3b82f6)
![RISC-V](https://img.shields.io/badge/ISA-miniRV%20%2F%20RISC--V-10b981)
![Pipeline](https://img.shields.io/badge/CPU-5--Stage%20Pipeline-f97316)
![Course Project](https://img.shields.io/badge/HITsz-Course%20Project-ef4444)

哈尔滨工业大学（深圳）计算机设计与实践课程项目：一个面向 miniRV 指令集的 Verilog CPU 实现。项目从单周期 CPU 扩展到五级流水线结构，覆盖取指、译码、执行、访存和写回，并处理数据冒险与控制冒险。

## 项目亮点

- 支持 37 条 miniRV / RISC-V 风格指令，在基础要求的 24 条指令上额外扩展 13 条。
- 实现单周期 CPU 与五级流水线 CPU，单周期频率约 50MHz，流水线频率约 100MHz。
- 使用前递与停顿处理数据冒险。
- 使用流水线暂停处理控制冒险。
- 包含 SoC 顶层、寄存器堆、ALU、控制器、存储器接口、数码管和 LED / Switch 外设驱动。

## 支持指令

```text
add, sub, and, or, xor,
sll, srl, sra, slt, sltu,
addi, andi, ori, xori,
slli, srli, srai, slti, sltiu,
lb, lbu, lh, lhu, lw,
sb, sh, sw,
beq, bne, blt, bltu, bge, bgeu,
lui, auipc, jal, jalr
```

## 核心模块

| 模块 | 作用 |
| --- | --- |
| `miniRV_SoC.v` | SoC 顶层连接 CPU、存储器与外设 |
| `myCPU.v` | CPU 主体结构 |
| `PC.v` | 程序计数器 |
| `Control.v` | 指令译码与控制信号生成 |
| `RegFile.v` | 通用寄存器堆 |
| `ALU.v` | 算术逻辑单元 |
| `IF_ID.v` / `ID_EX.v` / `EX_MEM.v` / `MEM_WB.v` | 五级流水线寄存器 |
| `Hazard_Detection.v` | 冒险检测与暂停控制 |
| `MEM.v` | 存储器访问 |
| `Bridge.v` | 存储器与外设地址桥 |
| `DigitDriver.v` / `LEDDriver.v` / `SwitchDriver.v` | 板级外设驱动 |

## 流水线结构

```text
IF  ->  ID  ->  EX  ->  MEM  ->  WB
取指    译码    执行     访存     写回
```

项目通过流水线寄存器分隔阶段，并在相关指令之间加入前递、停顿和控制暂停逻辑，使处理器能够在课程实验环境中稳定运行。

## 作者

我是来自哈工大深圳计算机学院的大三本科生，主要关注计算机系统、体系结构、软件工程和 AI 应用方向。这个仓库记录了我在计算机组成与 CPU 设计实践中的一次完整实现。

如果这个项目对你有帮助，欢迎给一个 Star。
