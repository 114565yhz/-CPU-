// Annotate this macro before synthesis
// `define RUN_TRACE

// TODO: 在此处定义你的宏
//Regfile的地址线宽度
`define RegAddrBus 4:0
//Regfile模块的数据线宽度
`define RegBus 31:0
//寄存器位数
`define RegNum 32

`define RstEnable 1
`define RstDisable 0

`define Forward_OP_WIDTH 2
//不同类型的指令的立即数符号扩展方式
`define Sext_OP_WDITH 3
`define Sext_I 0
`define Sext_S 1
`define Sext_B 2
`define Sext_U 3
`define Sext_J 4

`define NPC_SEL_WIDTH 2
`define NPC_SEL_NEXT 0
`define NPC_SEL_BRANCH 1
`define NPC_SEL_ALU 2
`define NPC_SEL_JAL 3

`define ALU_OP_WIDTH 4
`define ALUA_SEL_WIDTH 2
`define ALUA_SEL_RD1 0
`define ALUA_SEL_PC 1
`define ALUB_SEL_WIDTH 3
`define ALUB_SEL_RD2 0
`define ALUB_SEL_SEXT 1
`define ALU_ADD 0
`define ALU_SUB 1
`define ALU_AND 2
`define ALU_OR 3
`define ALU_XOR 4
`define ALU_SLL 5
`define ALU_SRL 6
`define ALU_SRA 7
`define ALU_SLT 8
`define ALU_SLTU 9
`define ALU_BEQ 10
`define ALU_BNE 11
`define ALU_BLT 12
`define ALU_BLTU 13
`define ALU_BGE 14
`define ALU_BGEU 15

`define RF_WSEL_WIDTH 2
`define RF_WSEL_ALUC 0
`define RF_WSEL_DRAM 1
`define RF_WSEL_PC4 2
`define RF_WSEL_SEXT 3

`define DRAM_SEL_WIDTH 3
`define DRAM_SEL_LW 0
`define DRAM_SEL_LH 1
`define DRAM_SEL_LB 2
`define DRAM_SEL_LBU 3
`define DRAM_SEL_LHU 4
`define DRAM_SEL_SW 5
`define DRAM_SEL_SB 6
`define DRAM_SEL_SH 7

`define OPCODE_R 7'b0110011
`define OPCODE_ADD 7'b0110011
`define OPCODE_SUB 7'b0110011
`define OPCODE_AND 7'b0110011
`define OPCODE_OR 7'b0110011
`define OPCODE_XOR 7'b0110011
`define OPCODE_SLL 7'b0110011
`define OPCODE_SRL 7'b0110011
`define OPCODE_SRA 7'b0110011
`define OPCODE_SLT 7'b0110011
`define OPCODE_SLTU 7'b0110011

`define OPCODE_I_REG 7'b0010011
`define OPCODE_ADDI 7'b0010011
`define OPCODE_ANDI 7'b0010011
`define OPCODE_ORI 7'b0010011
`define OPCODE_XORI 7'b0010011
`define OPCODE_SLLI 7'b0010011
`define OPCODE_SRLI 7'b0010011
`define OPCODE_SRAI 7'b0010011
`define OPCODE_SLTI 7'b0010011
`define OPCODE_SLTIU 7'b0010011

`define OPCODE_I_LOAD 7'b0000011
`define OPCODE_LB 7'b0000011
`define OPCODE_LBU 7'b0000011
`define OPCODE_LH 7'b0000011
`define OPCODE_LHU 7'b0000011
`define OPCODE_LW 7'b0000011

`define OPCODE_JALR 7'b1100111

`define OPCODE_S 7'b0100011
`define OPCODE_SB 7'b0100011
`define OPCODE_SH 7'b0100011
`define OPCODE_SW 7'b0100011

`define OPCODE_B 7'b1100011
`define OPCODE_BEQ 7'b1100011
`define OPCODE_BNE 7'b1100011
`define OPCODE_BLT 7'b1100011
`define OPCODE_BLTU 7'b1100011
`define OPCODE_BGE 7'b1100011
`define OPCODE_BGEU 7'b1100011

`define OPCODE_LUI 7'b0110111
`define OPCODE_AUIPC 7'b0010111
`define OPCODE_JAL 7'b1101111

`define FUNCT3_ADD_SUB 3'b000
`define FUNCT3_AND 	3'b111
`define FUNCT3_OR 	    3'b110
`define FUNCT3_XOR 	3'b100
`define FUNCT3_SLL 	3'b001
`define FUNCT3_SHIFT_RIGHT 3'b101
`define FUNCT3_SLT 	3'b010
`define FUNCT3_SLTU	3'b011
`define FUNCT3_ADDI	3'b000
`define FUNCT3_ANDI	3'b111
`define FUNCT3_ORI 	3'b110
`define FUNCT3_XORI	3'b100
`define FUNCT3_SLLI	3'b001
`define FUNCT3_SLTI	3'b010
`define FUNCT3_SLTIU	3'b011
`define FUNCT3_LB 	    3'b000
`define FUNCT3_LBU  	3'b100
`define FUNCT3_LH	    3'b001
`define FUNCT3_LHU  	3'b101
`define FUNCT3_LW	    3'b010
`define FUNCT3_JALR	3'b000
`define FUNCT3_SB	    3'b000
`define FUNCT3_SH	    3'b001
`define FUNCT3_SW	    3'b010
`define FUNCT3_BEQ	    3'b000
`define FUNCT3_BNE	    3'b001
`define FUNCT3_BLT	    3'b100
`define FUNCT3_BLTU	3'b110
`define FUNCT3_BGE	    3'b101
`define FUNCT3_BGEU	3'b111
//`define FUNCT3_LUI	-
//`define FUNCT3_AUIPC	-
//`define FUNCT3_JAL	-

`define FUNCT7_ADD  	7'b0000000
`define FUNCT7_SUB 	7'b0100000
`define FUNCT7_AND 	7'b0000000
`define FUNCT7_OR 	    7'b0000000
`define FUNCT7_XOR 	7'b0000000
`define FUNCT7_SLL 	7'b0000000
`define FUNCT7_SRL 	7'b0000000
`define FUNCT7_SRA 	7'b0100000
`define FUNCT7_SLT 	7'b0000000
`define FUNCT7_SLTU	7'b0000000
//`define FUNCT7_ADDI	
//`define FUNCT7_ANDI	
//`define FUNCT7_ORI 	
//`define FUNCT7_XORI	
`define FUNCT7_SLLI	7'b0000000
`define FUNCT7_SRLI	7'b0000000
`define FUNCT7_SRAI	7'b0100000
//`define FUNCT7_SLTI	
//`define FUNCT7_SLTIU	
//`define FUNCT7_LB 	
//`define FUNCT7_LBU	
//`define FUNCT7_LH	
//`define FUNCT7_LHU	
//`define FUNCT7_LW	
//`define FUNCT7_JALR	
//`define FUNCT7_SB	
//`define FUNCT7_SH	
//`define FUNCT7_SW	
//`define FUNCT7_BEQ	
//`define FUNCT7_BNE	
//`define FUNCT7_BLT	
//`define FUNCT7_BLTU	
//`define FUNCT7_BGE	
//`define FUNCT7_BGEU	
//`define FUNCT7_LUI	
//`define FUNCT7_AUIPC	
//`define FUNCT7_JAL	

`define DIGIT 12'h000
`define LED 12'h060
`define SWITCH 12'h070
// 外设I/O接口电路的端口地址
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078
