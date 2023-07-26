module top_tb;

    reg clk, rst_n;

    top U_top (
        .clk    (clk    ),
        .rst_n  (rst_n  )
    );

    always begin
        clk <= 1; #5;
        clk <= 0; #5;
    end

    initial begin
        rst_n <= 1; #1;
        rst_n <= 0; #1;
        rst_n <= 1;

        #400 $stop;
    end

endmodule
