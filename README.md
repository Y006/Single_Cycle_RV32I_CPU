一个适合初学者学习的RV32I指令集cpu实现

目前实现了大部分指令并且进行了初步验证

包括RTL代码、RISCV 汇编和 ModelSim 仿真

汇编语言编译为二进制需要使用 RISCV 编译器，这里选择的 [GNU MCU Eclipse RISC-V Embedded GCC v8.2.0-2.2 20190521](https://github.com/ilg-archived/riscv-none-gcc/releases/tag/v8.2.0-2.2-20190521)



文件分析：

1. 首先是top_tb：主要是生成时钟信号和复位信号，然后例化top模块进行仿真测试。
2. 然后是top：top模块中例化了三个子模块，分别是指令存储器（imem）、数据存储器（dmem）和RISCV逻辑（riscv）。RISCV逻辑使用指令地址从指令存储器中读出指令然后解码指令并执行。加载和存储数据时RISCV逻辑与数据存储器进行交互将数据在寄存器和数据存储器之间搬移。
3. riscv：包括解码器（decode）和数据通路（datapath）。解码器是一个组合逻辑，将输入的指令进行解码得到控制信号。控制信号控制数据通路中的选择器和状态元素以确保正确的输入和操作。数据通路中包含寄存器，ALU、立即数扩展单元和PC指针更新触发器等状态元素以及多个选择器。
4. decode：解码器属于组合逻辑电路，输入为指令，输出为控制信号。RISCV中使用opcode、funct3和funct7对指令进行划分。RV32I的每一条指令都包含opcode，可以用来划分为不同的type，然后funct3和funct7可以进一步确定到每一种type下具体的指令，并且用来确定ALU执行的运算操作。
5. datapath：数据通路中包含状态元素和选择器。状态元素包含寄存器文件、ALU、PC指针更新触发器和立即数扩展单元。选择器包含选择寄存器的写入值、PC指针下一次指向的值和ALU的输入值。
6. regfile、alu和extend：数据通路中的状态元素
7. imem和dmem：存储器仿真代码



测试方法：

1. 21条算数指令，包含I-type（一个立即数和一个寄存器作为操作数）和R-type（两个寄存器作为操作数）两种：算数类型指令最终会将计算得到的结果存在寄存器中，因此观察regfile.write_data3数据是否为计算结果即可
2. lui指令：将扩展后的立即数放到寄存器中，因此观察regfile.write_data3是否为正确扩展后的立即数即可
3. auipc指令：将扩展后的立即数与当前PC相加然后存入到寄存器中，仍然是观察regfile.write_data3的值
4. Jal指令：无条件跳转会保存PC值，因此需要观察regfile.write_data3，同时要观察下一个PC的值是否正确的进行了跳转
5. B-type：有条件跳转观察下一个PC值即可知道有没有正确执行
6. load指令：观察regfile.write_data3
7. store指令：观察dmem.wd

总结：U_regfile.write_data3、U_rvsingle.Instr、U_rvsingle.PC、U_dmem.wd、

```tcl
add wave -position insertpoint sim:/top_tb/*
add wave -position insertpoint  \
sim:/top_tb/U_top/U_rvsingle/Instr \
sim:/top_tb/U_top/U_rvsingle/PC
add wave -position insertpoint  \
sim:/top_tb/U_top/U_rvsingle/U_datapath/U_regfile/wirte_enable3
add wave -position insertpoint  \
sim:/top_tb/U_top/U_dmem/wd
```

