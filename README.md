# miniRV CPU（HITSZ 计算机设计与实践）

本仓库实现了一个基于 **RISC-V RV32I 子集** 的 CPU 系统，包含：

- 五级流水 CPU 核（支持数据前递、停顿与分支冲刷）
- 外设桥接与数码管/LED/开关驱动
- SoC 顶层集成（`miniRV_SoC.v`）

> 项目原始说明：哈尔滨工业大学（深圳）计算机科学与技术学院 2025 夏计算机设计与实践实验。

---

## 1. 指令支持

当前共支持 **37 条**指令（在基础 24 条上扩展 13 条）：

- R-type: `add, sub, and, or, xor, sll, srl, sra, slt, sltu`
- I-type(ALU): `addi, andi, ori, xori, slli, srli, srai, slti, sltiu`
- Load: `lb, lbu, lh, lhu, lw`
- Store: `sb, sh, sw`
- Branch: `beq, bne, blt, bltu, bge, bgeu`
- Jump: `jal, jalr`
- U-type: `lui, auipc`

---

## 2. 性能与实现特性

- 单周期 CPU：50 MHz
- 流水线 CPU：100 MHz
- 数据冒险：通过 **forwarding + stall** 处理
- 控制冒险：通过 **流水线 flush/暂停** 处理

---

## 3. 代码结构（按功能分类）

虽然目前 Verilog 文件位于仓库根目录，但逻辑上可分为以下几类：

### 3.1 CPU 核心与流水线

- 顶层与总线接口
  - `myCPU.v`：CPU 五级流水主数据通路与控制通路
  - `miniRV_SoC.v`：SoC 顶层，连接 CPU、存储器与外设
  - `Bridge.v`：总线地址映射与外设桥接

- IF/ID/EX/MEM/WB 级寄存器
  - `IF_ID.v`, `ID_EX.v`, `EX_MEM.v`, `MEM_WB.v`

- 功能模块
  - `PC.v`, `NPC.v`：PC 更新与 next PC 选择
  - `Control.v`：指令译码与控制信号生成
  - `RegFile.v`：寄存器堆
  - `ALU.v`：算术逻辑运算
  - `SEXT.v`：立即数扩展
  - `ALU_input_MUX.v`, `EX_wD_MUX.v`, `MEM_wD_MUX.v`：写回与运算输入选择
  - `Hazard_Detection.v`：数据冒险/控制冒险检测与处理
  - `MEM.v`：访存宽度适配（byte/halfword/word）与读写拼接

### 3.2 外设与显示

- `DigitDriver.v`：数码管驱动
- `LEDDriver.v`：LED 驱动
- `SwitchDriver.v`：开关输入映射
- `counter.v`：计数/分频辅助模块

### 3.3 公共定义

- `defines.vh`：控制编码、总线宽度、宏定义

---

## 4. 五级流水数据流简析

1. **IF**：`PC` 给出取指地址，`NPC` 根据分支/跳转结果选择下一条 PC。  
2. **ID**：`Control` 解码，`RegFile` 读寄存器，`SEXT` 生成立即数。  
3. **EX**：`ALU` 运算，执行分支判断，得到访存地址/算术结果。  
4. **MEM**：`MEM` 模块与总线交互，完成 load/store 对齐与字节选择。  
5. **WB**：将 ALU 结果、内存读出值或 PC+4 选择后写回寄存器堆。  

---

## 5. 冒险处理策略

- **Data Hazard（RAW）**
  - 优先通过 EX/MEM/WB 结果前递到 EX 段输入
  - 对 load-use 等无法及时前递场景触发停顿（`stall`）

- **Control Hazard（branch/jump）**
  - 在分支结果确定后，对前级流水寄存器执行 flush
  - 通过 `flush_IF_ID` 与 `flush_ID_EX` 清除错误路径指令

---

## 6. 建议的后续优化方向

- 增加 `docs/` 下的时序图和数据通路图（可用 mermaid）
- 引入统一 testbench 与自动化回归（如 Icarus/Verilator + 脚本）
- 将代码目录物理重构为 `rtl/core`, `rtl/periph`, `rtl/include`
- 补充 CSR/异常中断支持，扩展到更完整 RV32I 系统

---

如果这个项目对你有帮助，欢迎点个 ⭐。
