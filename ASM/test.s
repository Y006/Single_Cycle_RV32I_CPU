# =====================================================================================================================
# .text
# .global main
# 
# main:
#         # 建议观察的波形:
#         # U_top.Instr, U_top.PC, U_regfile.I_a1, U_regfile.I_a2, U_regfile.I_a3, U_regfile.I_wd3, U_decode.op, U_alu.ALUCtrl
#         # 测试R型指令
#         addi x1, x0, 5       # addi: x1 = 5
#         addi x2, x0, 8       # addi: x2 = 8   
# 
#         add x3, x1, x2       # add: x3 = x1 + x2 = 13
#         sub x4, x2, x1       # sub: x4 = x2 - x1 = 3
#         sll x5, x1, x2       # sll: x5 = x1 << 8 = 1280
#         slt x6, x1, x2       # slt: x6 = (x1 < x2) ? 1 : 0 = 1
#         sltu x7, x1, x2      # sltu: x7 = (x1 < x2) ? 1 : 0 (unsigned comparison) = 1
#         xor x8, x1, x2       # xor: x8 = x1 ^ x2 = 13
#         srl x9, x2, x1       # srl: x9 = x2 >> 5 = 0
#         sra x10, x2, x1      # sra: x10 = x2 >> 5 (arithmetic shift) = 0
#         or x11, x1, x2       # or: x11 = x1 | x2 = 13
#         and x12, x1, x2      # and: x12 = x1 & x2 = 0   
# 
#         # 测试I型指令(运算类型)
#         addi x13, x0, 10     # addi: x13 = 10
#         addi x14, x0, -3     # addi: x14 = -3
# 
#         addi x15, x13, 7     # addi: x15 = x13 + 7 = 17
#         slli x17, x13, 2     # slli: x17 = x13 << 2 = 40
#         slti x18, x14, 0     # slti: x18 = (x14 < 0) ? 1 : 0 = 1
#         sltiu x19, x13, 20   # sltiu: x19 = (x13 < 20) ? 1 : 0 (unsigned comparison) = 1
#         xori x20, x14, 7     # xori: x20 = x14 ^ 7 = -6
#         srli x21, x13, 3     # srli: x21 = x13 >> 3 = 1
#         srai x22, x14, 2     # srai: x22 = x14 >> 2 (arithmetic shift) = -1
#         ori x23, x13, 15     # ori: x23 = x13 | 15 = 15
#         andi x24, x14, 6     # andi: x24 = x14 & 6 = 4
# 
# loop:
#         beq x0, x0, loop     # Loop back to the beginning
# 
# end:
#         # End of program
# =====================================================================================================================


# =====================================================================================================================
# .text
# .global main
# 
# main:
#         # 初始化寄存器
#         addi x1, x0, 5       # x1 = 5
#         addi x2, x0, 8       # x2 = 8
#         addi x3, x0, 5       # x3 = 5
#         addi x4, x0, 8       # x4 = 8
# 
#         # 测试 beq
#         beq x1, x2, label1   # 5 == 8? No, should not jump to label1
#         addi x5, x0, 1       # As we did not jump, x5 = 1
#         j continue1
# 
# label1:
#         addi x5, x0, 2       # If we jumped, x5 = 2
# 
# continue1:
#         beq x1, x3, label2   # 5 == 5? Yes, should jump to label2
#         addi x6, x0, 3       # If we didn't jump, x6 = 3
#         j continue2
# 
# label2:
#         addi x6, x0, 4       # If we jumped, x6 = 4
# 
# continue2:
# 
#         # 测试 bne
#         bne x1, x2, label3   # 5 != 8? Yes, should jump to label3
#         addi x7, x0, 5       # If we didn't jump, x7 = 5
#         j continue3
# 
# label3:
#         addi x7, x0, 6       # If we jumped, x7 = 6
# 
# continue3:
#         bne x1, x3, label4   # 5 != 5? No, should not jump to label4
#         addi x8, x0, 7       # As we did not jump, x8 = 7
#         j continue4
# 
# label4:
#         addi x8, x0, 8       # If we jumped, x8 = 8
# 
# continue4:
# 
#         # 测试 blt
#         blt x1, x2, label5   # 5 < 8? Yes, should jump to label5
#         addi x9, x0, 9       # If we didn't jump, x9 = 9
#         j continue5
# 
# label5:
#         addi x9, x0, 10      # If we jumped, x9 = 10
# 
# continue5:
#         blt x2, x1, label6   # 8 < 5? No, should not jump to label6
#         addi x10, x0, 11     # As we did not jump, x10 = 11
#         j continue6
# 
# label6:
#         addi x10, x0, 12     # If we jumped, x10 = 12
# 
# continue6:
# 
#         # 测试 bge
#         bge x1, x2, label7   # 5 >= 8? No, should not jump to label7
#         addi x11, x0, 13     # As we did not jump, x11 = 13
#         j continue7
# 
# label7:
#         addi x11, x0, 14     # If we jumped, x11 = 14
# 
# continue7:
#         bge x2, x1, label8   # 8 >= 5? Yes, should jump to label8
#         addi x12, x0, 15     # If we didn't jump, x12 = 15
#         j continue8
# 
# label8:
#         addi x12, x0, 16     # If we jumped, x12 = 16
# 
# continue8:
# 
#         # 测试 bltu
#         bltu x1, x2, label9  # 5U < 8U? Yes, should jump to label9
#         addi x13, x0, 17     # If we didn't jump, x13 = 17
#         j continue9
# 
# label9:
#         addi x13, x0, 18     # If we jumped, x13 = 18
# 
# continue9:
#         bltu x2, x1, label10 # 8U < 5U? No, should not jump to label10
#         addi x14, x0, 19     # As we did not jump, x14 = 19
#         j continue10
# 
# label10:
#         addi x14, x0, 20     # If we jumped, x14 = 20
# 
# continue10:
# 
#         # 测试 bgeu
#         bgeu x1, x2, label11 # 5U >= 8U? No, should not jump to label11
#         addi x15, x0, 21     # As we did not jump, x15 = 21
#         j continue11
# 
# label11:
#         addi x15, x0, 22     # If we jumped, x15 = 22
# 
# continue11:
#         bgeu x2, x1, label12 # 8U >= 5U? Yes, should jump to label12
#         addi x16, x0, 23     # If we didn't jump, x16 = 23
#         j continue12
# 
# label12:
#         addi x16, x0, 24     # If we jumped, x16 = 24
# 
# continue12:
# 
# loop:
#         beq x0, x0, loop     # Loop back to the beginning
# 
# end:
#         # End of program
# =====================================================================================================================


# =====================================================================================================================
.text
.global main

main:
        # 测试 lui
        lui x1, 0x1         # x1 = 0x10000
        lui x2, 0xFFFFF     # x2 = 0xFFFFF00000, 注意这是一个负数
        lui x3, 0xA5A5A     # x3 = 0xA5A5A0000

        # 测试 auipc
        auipc x4, 0x1       # x4 = PC + 0x10000
        auipc x5, 0xFFFFF   # x5 = PC + 0xFFFFF00000
        auipc x6, 0xA5A5A   # x6 = PC + 0xA5A5A0000

        # 调用函数
        auipc x10, 0
        addi x10, x10, 16   # 假设函数 function 在 main 之后的16字节处
        jalr x11, x10, 0    # 跳转到 function 并保存返回地址到 x11
        
        

loop:
        beq x0, x0, loop     # Loop back to the beginning

function:
        # 执行一些操作，比如将 x1 置 0
        addi x1, x0, 0

        # 返回
        jalr x0, x11, 0      # 跳回到调用函数的地方

end:
        # End of program

# =====================================================================================================================



