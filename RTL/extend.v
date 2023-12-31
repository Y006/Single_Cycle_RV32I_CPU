module extend (
    input       [31:7] instr,
    input       [2:0 ] immSrc,
    output reg  [31:0] immExt
);

    always @(*)
    begin
        case(immSrc)
            3'b000: 
                immExt = {{20{instr[31]}}, instr[31:20]};                                       // I-type
            3'b001: 
                immExt = {{20{instr[31]}}, instr[31:25], instr[11:7]};                          // S-type (stores)
            3'b010: 
                immExt = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};          // B-type (branches)
            3'b100:
                immExt = {instr[31], instr[30:12], {12{1'b0}}};                                 // U-type
            3'b011: 
                immExt = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};        // J-type (jal)
            default:
                immExt = 32'b0;                                                                 // undefined
        endcase
    end

endmodule
