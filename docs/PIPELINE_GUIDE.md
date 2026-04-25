# Pipeline Guide（流水线解析说明）

本文档用于补充 `myCPU.v` 的阅读路径，帮助快速理解该 CPU 的控制与数据通路。

## 1. 顶层端口语义

`myCPU` 暴露两类接口：

- **取指接口（IROM）**：
  - `inst_addr`：按字寻址的指令地址（`if_pc[15:2]`）
  - `inst`：当前取出的 32-bit 指令
- **数据总线接口（Bridge）**：
  - `Bus_addr` / `Bus_wdata` / `Bus_wen`：写请求
  - `Bus_rdata`：读返回

## 2. 五级流水概览

- **IF**：`PC` + `NPC`
  - `PC` 在时钟沿更新
  - `NPC` 根据 `ex_npc_op`、`ex_alu_f`、`ex_alu_c` 产生下一条 PC
- **ID**：`Control` + `RegFile` + `SEXT`
  - 解码指令，生成 ALU/访存/写回选择控制信号
  - 读寄存器，构造立即数
- **EX**：`ALU`
  - 完成算术逻辑运算与分支比较
- **MEM**：`MEM`
  - 完成 load/store 的字节宽度处理（`dram_sel`）
- **WB**：`MEM_WB` + 回写
  - 将最终结果写入寄存器堆

## 3. 关键控制信号

- `stall`：暂停 `PC` 和部分流水寄存器更新
- `flush_if_id`：清空 IF/ID 级错误路径指令
- `flush_id_ex`：清空 ID/EX 级错误路径指令
- `Forward_A_en` / `Forward_B_en`：启用前递
- `A_forward` / `B_forward`：前递数据

## 4. 冒险处理机制

`Hazard_Detection` 模块统一处理：

1. **前递优先**：若目标寄存器匹配且数据已在 EX/MEM/WB 产生，则旁路到 EX 输入；
2. **必要停顿**：对 load-use 等无法当拍前递的情况，拉高 `stall`；
3. **分支冲刷**：分支命中后触发 `flush_IF_ID` 与 `flush_ID_EX`，丢弃错误路径。

## 5. 推荐阅读顺序

1. `defines.vh`（先看控制编码）
2. `Control.v`（看 opcode/funct 到控制信号映射）
3. `myCPU.v`（看模块连接关系）
4. `Hazard_Detection.v`（看流水线正确性保障）
5. `MEM.v`（看 load/store 字节选择与扩展）

## 6. 结构化重构建议（可选）

若后续准备进一步工程化，可将文件移动为：

- `rtl/core/`：`myCPU.v`, `Control.v`, `ALU.v`, `RegFile.v`, `SEXT.v`, `PC.v`, `NPC.v`
- `rtl/pipeline/`：`IF_ID.v`, `ID_EX.v`, `EX_MEM.v`, `MEM_WB.v`, `Hazard_Detection.v`
- `rtl/memory/`：`MEM.v`, `Bridge.v`
- `rtl/periph/`：`DigitDriver.v`, `LEDDriver.v`, `SwitchDriver.v`, `counter.v`
- `rtl/include/`：`defines.vh`

并在顶层构建脚本（Makefile 或仿真脚本）里统一维护源文件列表。
