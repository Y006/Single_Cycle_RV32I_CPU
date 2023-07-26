
//来自RISC-V-Reader-Chinese-v2p1第25页的表19.2

// opcode:
// U-type
`define OPCODE_LUI      7'b011_0111
`define OPCODE_AUIPC    7'b001_0111
// J-type
`define OPCODE_JAL      7'b110_1111
// I-type
`define OPCODE_JALR     7'b110_0111
`define OPCODE_LOAD     7'b000_0011
`define OPCODE_ALUI     7'b001_0011
`define OPCODE_FENCE    7'b000_1111
`define OPCODE_SYSTEM   7'b111_0011
// B-type
`define OPCODE_BRANCH   7'b110_0011
// S-type
`define OPCODE_STORE    7'b010_0011
// R-type
`define OPCODE_ALUR     7'b011_0011

// ALU ctrl signal:
// I-type and -type 
`define ALU_CTRL_ADD      4'b0000
`define ALU_CTRL_SUB      4'b1000
`define ALU_CTRL_SLL      4'b0001
`define ALU_CTRL_SLT      4'b0010
`define ALU_CTRL_SLTU     4'b0011
`define ALU_CTRL_XOR      4'b0100
`define ALU_CTRL_SRL      4'b0101
`define ALU_CTRL_SRA      4'b1101
`define ALU_CTRL_OR       4'b0110
`define ALU_CTRL_AND      4'b0111
// B-type
`define ALU_CTRL_EQ       4'b1001
`define ALU_CTRL_NEQ      4'b1010
`define ALU_CTRL_GE       4'b1100
`define ALU_CTRL_GEU      4'b1011
// wrong signal
`define ALU_CTRL_XXX      4'b1111

// funt3 signal:
// B-type
`define FUNCT3_BEQ      3'b000
`define FUNCT3_BNE      3'b001
`define FUNCT3_BLT      3'b100
`define FUNCT3_BGE      3'b101
`define FUNCT3_BLTU     3'b110
`define FUNCT3_BGEU     3'b111
// funct3 0f R-type is the same as I-typr
// R-type                           // I-type
`define FUNCT3_ADD_SUB  3'b000      // `define FUNCT3_ADDI      3'b000        
`define FUNCT3_SLL      3'b001      // `define FUNCT3_SLLI      3'b001
`define FUNCT3_SLT      3'b010      // `define FUNCT3_SLTI      3'b010
`define FUNCT3_SLTU     3'b011      // `define FUNCT3_SLTIU     3'b011
`define FUNCT3_XOR      3'b100      // `define FUNCT3_XORI      3'b100
`define FUNCT3_SRL_SRA  3'b101      // `define FUNCT3_SRLI_SRAI 3'b101
`define FUNCT3_OR       3'b110      // `define FUNCT3_ORI       3'b110
`define FUNCT3_AND      3'b111      // `define FUNCT3_ANDI      3'b111


