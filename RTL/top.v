module top (
    input clk,
    input rst_n
);
    wire [31:0] Instr;      // 指令，从指令存储器U_imem中读取加载到U_rvsingle中进行解码
    wire [31:0] PC;         // PC指针，在数据通路中进行更新，输入到指令存储器U_imem得到指令
    
    wire [31:0] MemDataAdr; // 数据存储器的数据地址
    wire [31:0] ReadData;   // 数据存储器读出的数据
    wire [31:0] WriteData;  // 数据存储器写入的数据
    wire        MemWriteEn; // 使能数据存储器写入数据

// =============================== RISCV逻辑 =================================
    riscv U_rvsingle (
        .clk         (clk        ),
        .rst_n       (rst_n      ),
        // 与指令存储器的接口
        .PC          (PC         ),
        .Instr       (Instr      ),
        // 与数据存储器的接口
        .MemWriteEn  (MemWriteEn ),
        .MemDataAdr  (MemDataAdr ),
        .WriteData   (WriteData  ),
        .ReadData    (ReadData   )
    );
// =============================== RISCV逻辑 =================================

// =============================== 指令存储器 =================================
    imem U_imem (
        .a      (PC     ),
        .rd     (Instr  )
    );
// =============================== 指令存储器 =================================

// =============================== 数据存储器 =================================
    dmem U_dmem (
        .clk    (clk        ),
        .rst_n  (rst_n      ),
        .we     (MemWriteEn ),
        .a      (MemDataAdr ),
        .wd     (WriteData  ),
        .rd     (ReadData   )
    );
// =============================== 数据存储器 =================================

endmodule
