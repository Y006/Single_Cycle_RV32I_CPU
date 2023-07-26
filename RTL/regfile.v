module regfile (
    input           clk,
    input           rst_n,
    input   [4 :0]  addr3,
    input           wirte_enable3,
    input   [31:0]  write_data3,
    input   [4 :0]  addr1, addr2,
    output  [31:0]  read_data1, read_data2
);

    // RSICV 架构中寄存器文件组成：32个32位的寄存器
    reg [31:0] reg_files[31:0];    

    // 三端口的寄存器文件
    // 读出端口 (A1/RD1, A2/RD2)
    // 上升沿写入的三端口 (A3/WD3/WE3)
    // 寄存器 0 固定为 0

    integer i;

    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
                for ( i = 0; i < 32; i = i + 1)
                    reg_files[i] <= 32'd0;
        end
        else if (wirte_enable3)
                reg_files[addr3] <= write_data3;
    end

    assign read_data1 = (addr1 != 0) ? reg_files[addr1] : 0;
    assign read_data2 = (addr2 != 0) ? reg_files[addr2] : 0;

endmodule