module datapath (
    input                    clk,                   
    input                    rst_n,                 
    input        [31:0]      Instr,                 
    // 立即数扩展
    input        [ 2:0]      ImmSrc,                // 立即数的来源(于哪种类型的指令)
    // ALU控制
    input                    ALUSrcB,               // ALU 端口 B(数据)的来源
    input                    ALUSrcA,               // ALU 端口 A(数据)的来源
    input        [ 3:0]      ALUControl,            // ALU 控制信号
    // 寄存器控制
    input                    RegWriteEn,            // (是否)进行寄存器写入操作
    input        [ 1:0]      RegResultSrc,          // 寄存器写入数据的来源
    // 跳转控制信号
    input        [ 2:0]      TransferCtrl,          // 跳转控制信号
    // 存储器信号
    input        [31:0]      MemReadData,           // 数据存储器->寄存器
    output       [31:0]      MemWriteData,          // 寄存器->数据存储器
    output       [31:0]      MemDataAdr,            // 数据存储器地址
    output  reg  [31:0]      PC                     // 更新后的 PC 指针
);

    reg     [31:0]  write_data3;    
    wire    [31:0]  read_data1;     
    wire    [31:0]  read_data2;     

    wire    [31:0]  immExt;         // 扩展后的立即数

    wire    [31:0]  ALU_A;          // ALU 的第一个输入端口
    wire    [31:0]  ALU_B;          // ALU 的第二个输入端口
    wire    [31:0]  ALUResult;

    reg     [31:0]  PCNext;         // 下一周期的 PC 值

//=============================== 例化扩展单元 ====================================
    extend U_extend (
        .instr          (Instr[31:7]),
        .immSrc         (ImmSrc     ),
        .immExt         (immExt     )
    );
//=============================== 例化扩展单元 ====================================

// =========================== 选择器：ALU输入 ====================================
    // ALU有两个输入端口A和B
    // 0. 对于auipc指令,需要将PC值与立即数相加,因此ALU_A应该输入为PC值,其余指令输入值均为RD1
    // 1. 对于I型指令来说，指令结构中没有rs2只有立即域，因此送入SrcB的都是扩展后的立即数
    // 2. 对于S型指令来说，指令结构中有rs2也有立即域，但是寻址时是将寄存器中值与“立即数”相加，因此送入SrcB的都是扩展后的立即数
    // 3. 对于B型指令来说，指令结构中有rs2也有立即域，此时由于B型指令中立即数提供了一个直接的地址不需要计算，送入ALU的应该是两个寄存器读出值，因此送入SrcB的是寄存器读出值
    // 4. 对于R型指令来说，指令结构中只有rs2没有立即域，因此送入SrcB的都是寄存器读出值
    assign ALU_A = ALUSrcA ? PC : read_data1;
    assign ALU_B = ALUSrcB ? immExt : MemWriteData;
// =========================== 选择器：ALU输入 ====================================

// ============================== 例化ALU =========================================
    alu U_alu (
        .ALU_A               (ALU_A       ),
		.ALU_B               (ALU_B       ),
		.ALUCtrl            (ALUControl   ),
		.ALUResult          (ALUResult    )
    );
// ============================== 例化ALU =========================================

// =========================== 一个D触发器，用于更新PC指针 ==========================
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            PC <= 32'h0;
        else
            PC <= PCNext;
    end
// =========================== 一个D触发器，用于更新PC指针 ==========================

// ========================== 选择器：下一个PC值的选择 ==============================
    // PC的选择非常简单，只有两种情况：跳转到某一个位置或者顺次加4
    // 1. 对于R型指令,S型指令,U型指令和大多数I型指令来说PCNext都是当前PC加4
    // 2. 对于B型指令和J型指令,PCNext为当前PC值与扩展后的立即数相加
    // 3. 对于I型指令中的jalr来说,PCNext为ALU输出与0相与
    always @(*) begin
        case (TransferCtrl)
            3'b000: PCNext = PC + 32'd4;        
            3'b001: PCNext = PC + immExt;       // B-type
            3'b010: PCNext = PC + immExt;       // J-type
            3'b011: PCNext = ALUResult & (~1);  // jalr
            default: PCNext = PC;
        endcase
    end
// ========================== 选择器：下一个PC值的选择 ==============================

// ============================ 例化寄存器文件 =====================================
    regfile U_regfile (
        .clk            (clk                ),    
        .rst_n          (rst_n              ),    
        .addr3          (Instr[11: 7]       ),    // 地址线，仿真时使用无符号十进制，范围是0-31
        .wirte_enable3  (RegWriteEn         ),    
        .write_data3    (write_data3        ),    
        .addr1          (Instr[19:15]       ),    
        .addr2          (Instr[24:20]       ),    
        .read_data1     (read_data1         ),    
        .read_data2     (read_data2         )     
    );
// ============================ 例化寄存器文件 =====================================

// ========================== 选择器：寄存器写入情况 ================================
    // 分析：
    // 1. 对于load和store指令，应该将dmem读出端接到reg的输入端（wd3）
    // 2. 对于R-type和I-type（计算类），应该将ALU的输出即计算结果接到reg的输入端（wd3）
    // 3. 对于J-type，应该将PCPlus4的输出接到reg的输入端（wd3），这是因为对于“无条件跳转”，我们需要寄存器存储当前的地址，然后再跳转
    // 4. 对于U-type（lui），将扩展后的立即数加载到寄存器中
    always @(*) begin
        case (RegResultSrc)
            2'b00:
                write_data3 = ALUResult;        // R-type and some I-type
            2'b01:
                write_data3 = MemReadData;      // load or store
            2'b10:
                write_data3 = PC + 32'd4;       // J-type
            2'b11:
                write_data3 = immExt;           // U-type(lui)
            default: 
                write_data3 = 32'b0;
        endcase
    end
// ========================== 选择器：寄存器写入情况 ================================

// ============================ 数据存储器写入情况 ==================================
    assign MemDataAdr = ALUResult;
    assign MemWriteData = read_data2;
// ============================ 数据存储器写入情况 ==================================

endmodule
