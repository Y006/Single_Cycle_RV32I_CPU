module riscv(
    input            clk,
    input            rst_n,
    input    [31:0]  Instr,
    input    [31:0]  ReadData,
    output   [31:0]  PC,
    output           MemWriteEn,
    output   [31:0]  MemDataAdr,
    output   [31:0]  WriteData
);

    wire ALUSrcB, ALUSrcA, RegWriteEn;
    wire [1:0] ResultSrc;
    wire [2:0] ImmSrc;
    wire [3:0] ALUControl;
    wire [2:0] TransferCtrl;

// =============================== 解码器 =================================
    // 作用：根据当前执行的指令解码得到数据通路需要的控制信号
    decode U_decode (
        // 输入指令
        .Instr          (Instr          ),
        // 解码得到控制信号
        // 立即数扩展
        .ImmSrc         (ImmSrc         ),
        // ALU控制
        .ALUSrcB        (ALUSrcB        ),
        .ALUSrcA        (ALUSrcA        ),
        .ALUControl     (ALUControl     ),
        // 寄存器控制
        .RegWriteEn     (RegWriteEn     ),
        .RegResultSrc   (ResultSrc      ),
        // 跳转控制信号
        .TransferCtrl   (TransferCtrl   ),
        // 存储器信号
        .MemWriteEn     (MemWriteEn     )
    );
// =============================== 解码器 =================================

// =============================== 数据通路 ================================
    // 作用：使用组合逻辑连接状态元素硬件，使用解码器输出的控制信号进行控制
    datapath U_datapath (
        .clk                (clk            ),
        .rst_n              (rst_n          ),
        .Instr              (Instr          ),
        // 立即数扩展
        .ImmSrc             (ImmSrc         ),
        // ALU控制
        .ALUSrcB            (ALUSrcB        ),
        .ALUSrcA            (ALUSrcA        ),
        .ALUControl         (ALUControl     ),
        // 寄存器控制
        .RegWriteEn         (RegWriteEn     ),
        .RegResultSrc       (ResultSrc      ),
        // 跳转控制信号
        .TransferCtrl       (TransferCtrl   ),
        // 存储器信号
        .MemDataAdr         (MemDataAdr     ),
        .MemWriteData       (WriteData      ),
        .MemReadData        (ReadData       ),
        .PC                 (PC             )
    );
// =============================== 数据通路 ================================

endmodule
