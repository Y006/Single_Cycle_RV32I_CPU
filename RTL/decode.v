`include "define.v"

module decode (
    input               [31:0]  Instr,              // 待解码的指令
    // 立即数扩展
    output      reg     [ 2:0]  ImmSrc,             // 立即数的来源(于哪种类型的指令)
    // ALU控制
    output      reg             ALUSrcB,            // ALU 端口 B(数据)的来源
    output      reg             ALUSrcA,            // ALU 端口 A(数据)的来源
    output      reg     [ 3:0]  ALUControl,         // ALU 控制信号
    // 寄存器控制
    output      reg             RegWriteEn,         // 寄存器写使能 
    output      reg     [ 1:0]  RegResultSrc,       // 这里选择了寄存器载入的结果的来源
    // 跳转控制信号
    output      reg     [ 2:0]  TransferCtrl,       // 跳转控制信号
    // 存储器信号
    output      reg             MemWriteEn          // 存储器写使能
);

    wire [6:0] op = Instr[6:0];
    wire [2:0] funct3 = Instr[14:12];
    wire       funct7_bit_5 = Instr[30];
    reg  [1:0] ALUOp;

    // ============================================================= 控制信号真值表 ================================================================
    // |Instruction  | op          | RegWriteEn    | ImmSrc  | ALUSrcB     | ALUSrcA    | MemWriteEn    | RegResultSrc    | ALUOp   | TransferCtrl|
    // |load         | 000_0011    | 1             | 000     | 1           | 0          | 0             | 01              | 00      | 000         |
    // |store        | 010_0011    | 0             | 001     | 1           | 0          | 1             | xx              | 00      | 000         |
    // |R-type       | 011_0011    | 1             | xxx     | 0           | 0          | 0             | 00              | 10      | 000         |
    // |B-type       | 110_0011    | 0             | 010     | 0           | 0          | 0             | xx              | 01      | 001         |
    // |I_type       | 001_0011    | 1             | 000     | 1           | 0          | 0             | 00              | 10      | 000         |
    // |jal          | 110_1111    | 1             | 011     | x           | 0          | 0             | 10              | xx      | 010         |
    // |lui          | 011_0111    | 1             | 100     | x           | 0          | 0             | 11              | xx      | 000         |
    // |auipc        | 001_0111    | 1             | 100     | 1           | 1          | 0             | 00              | 00      | 000         |
    // |jalr         | 110_0111    | 1             | 000     | 1           | 0          | 0             | 10              | 00      | 011         |
    // ============================================================= 控制信号真值表 ================================================================

    always @(*) begin
        case(op)
            `OPCODE_LUI:
                begin
                    RegWriteEn = 1'b1; ImmSrc = 3'b100; ALUSrcB = 1'bx; ALUSrcA = 1'b0; MemWriteEn = 1'b0; RegResultSrc = 2'b11; ALUOp = 2'b00; TransferCtrl = 3'b000;
                end
            `OPCODE_AUIPC:
                begin
                    RegWriteEn = 1'b1; ImmSrc = 3'b100; ALUSrcB = 1'b1; ALUSrcA = 1'b1; MemWriteEn = 1'b0; RegResultSrc = 2'b00; ALUOp = 2'b00; TransferCtrl = 3'b000;
                end
            `OPCODE_LOAD:
                begin
                    RegWriteEn = 1'b1; ImmSrc = 3'b000; ALUSrcB = 1'b1; ALUSrcA = 1'b0; MemWriteEn = 1'b0; RegResultSrc = 2'b01; ALUOp = 2'b00; TransferCtrl = 3'b000;
                end
            `OPCODE_JALR:
                begin
                    RegWriteEn = 1'b1; ImmSrc = 3'b000; ALUSrcB = 1'b1; ALUSrcA = 1'b0; MemWriteEn = 1'b0; RegResultSrc = 2'b10; ALUOp = 2'b00; TransferCtrl = 3'b011;
                end
            `OPCODE_STORE:
                begin
                    RegWriteEn = 1'b0; ImmSrc = 3'b001; ALUSrcB = 1'b1; ALUSrcA = 1'b0; MemWriteEn = 1'b1; RegResultSrc = 2'b00; ALUOp = 2'b00; TransferCtrl = 3'b000;
                end
            `OPCODE_ALUR:
                begin
                    RegWriteEn = 1'b1; ImmSrc = 3'bxxx; ALUSrcB = 1'b0; ALUSrcA = 1'b0; MemWriteEn = 1'b0; RegResultSrc = 2'b00; ALUOp = 2'b10; TransferCtrl = 3'b000;
                end
            `OPCODE_BRANCH:
                begin
                    RegWriteEn = 1'b0; ImmSrc = 3'b010; ALUSrcB = 1'b0; ALUSrcA = 1'b0; MemWriteEn = 1'b0; RegResultSrc = 2'b00; ALUOp = 2'b01; TransferCtrl = 3'b001;
                end
            `OPCODE_ALUI:
                begin
                    RegWriteEn = 1'b1; ImmSrc = 3'b000; ALUSrcB = 1'b1; ALUSrcA = 1'b0; MemWriteEn = 1'b0; RegResultSrc = 2'b00; ALUOp = 2'b10; TransferCtrl = 3'b000;
                end
            `OPCODE_JAL:
                begin
                    RegWriteEn = 1'b1; ImmSrc = 3'b011; ALUSrcB = 1'bx; ALUSrcA = 1'b0; MemWriteEn = 1'b0; RegResultSrc = 2'b10; ALUOp = 2'b00; TransferCtrl = 3'b010;
                end
            default:
                begin
                    RegWriteEn = 1'bx; ImmSrc = 3'bxxx; ALUSrcB = 1'bx; ALUSrcA = 1'b0; MemWriteEn = 1'bx; RegResultSrc = 2'bxx; ALUOp = 2'bxx; TransferCtrl = 3'bxxx;
                end
        endcase
    end


    // ALU控制器:解码指令生成ALU的控制信号
    // ALU控制信号,使用到ALU的指令包括:加载指令,存储指令,B型指令,R型指令和I型指令中用于运算的指令

    always @(*) begin
        case (ALUOp)
            2'b00:  // load and store and auipc and jalr
                ALUControl = `ALU_CTRL_ADD;
            2'b01:  // B-type
                case (funct3)
                    `FUNCT3_BEQ: 
                        ALUControl = `ALU_CTRL_EQ;
                    `FUNCT3_BNE:
                        ALUControl = `ALU_CTRL_NEQ;
                    `FUNCT3_BLT:
                        ALUControl = `ALU_CTRL_SLT;
                    `FUNCT3_BGE:
                        ALUControl = `ALU_CTRL_GE;
                    `FUNCT3_BLTU:
                        ALUControl = `ALU_CTRL_SLTU;
                    `FUNCT3_BGEU:
                        ALUControl = `ALU_CTRL_GEU;
                    default: 
                        ALUControl = `ALU_CTRL_XXX;
                endcase 
            2'b10:  // R-type and I-type(operation)
                case (funct3)
                    `FUNCT3_ADD_SUB: 
                        if(funct7_bit_5 & op[5])
                            ALUControl = `ALU_CTRL_SUB;
                        else
                            ALUControl = `ALU_CTRL_ADD;
                    `FUNCT3_SLL:
                        ALUControl = `ALU_CTRL_SLL;
                    `FUNCT3_SLT:
                        ALUControl = `ALU_CTRL_SLT;
                    `FUNCT3_SLTU:
                        ALUControl = `ALU_CTRL_SLTU;
                    `FUNCT3_XOR:
                        ALUControl = `ALU_CTRL_XOR;
                    `FUNCT3_SRL_SRA:
                        if(funct7_bit_5 & op[5])
                            ALUControl = `ALU_CTRL_SRA;
                        else
                            ALUControl = `ALU_CTRL_SRL;
                    `FUNCT3_OR:
                        ALUControl = `ALU_CTRL_OR;
                    `FUNCT3_AND:
                        ALUControl = `ALU_CTRL_AND;
                    default: 
                        ALUControl = `ALU_CTRL_XXX;
                endcase 
            default: 
                ALUControl = `ALU_CTRL_XXX;
        endcase
    end

endmodule