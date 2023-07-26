module dmem (
    input           clk,
    input           rst_n,
    input           we,
    input   [31:0]  a,
    input   [31:0]  wd,
    output  [31:0]  rd
);

    reg [31:0] RAM[0:3000];

    assign rd = RAM[a[31:2]];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for ( i = 0; i < 3000; i = i + 1)
                RAM[i] <= 32'd0;
        end
        if(we) begin
                RAM[a[31:2]] <= wd;
        end
    end

endmodule
