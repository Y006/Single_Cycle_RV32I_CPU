module imem (
    input   [31:0]  a,
    output  [31:0]  rd
);

    reg [31:0] RAM [0:1050];

    initial begin
        // $display("read instr!");
        $readmemh("instruct_file.txt",RAM);
    end

    assign rd = RAM [a[31:2]];

endmodule
