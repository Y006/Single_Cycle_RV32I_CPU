`include "define.v"

module alu (
  input             [31:0]  ALU_A,
  input             [31:0]  ALU_B,
  input             [ 3:0]  ALUCtrl,
  output    reg     [31:0]  ALUResult
);

    always @(*) begin
        case(ALUCtrl)
            `ALU_CTRL_ADD:      ALUResult <= ALU_A + ALU_B;
            `ALU_CTRL_SUB:      ALUResult <= ALU_A - ALU_B;
            `ALU_CTRL_SLL:      ALUResult <= ALU_A << ALU_B;
            `ALU_CTRL_SLT:      ALUResult <= $signed(ALU_A) < $signed(ALU_B);
            `ALU_CTRL_SLTU:     ALUResult <= ALU_A < ALU_B;
            `ALU_CTRL_XOR:      ALUResult <= ALU_A ^ ALU_B;
            `ALU_CTRL_SRL:      ALUResult <= $signed(ALU_A) >>> ALU_B;
            `ALU_CTRL_SRA:      ALUResult <= ALU_A >> ALU_B;
            `ALU_CTRL_OR:       ALUResult <= ALU_A | ALU_B;
            `ALU_CTRL_AND:      ALUResult <= ALU_A & ALU_B;

            `ALU_CTRL_EQ:       ALUResult <= ALU_A == ALU_B;
            `ALU_CTRL_NEQ:      ALUResult <= ALU_A != ALU_B;
            `ALU_CTRL_GE:       ALUResult <= $signed(ALU_A) >= $signed(ALU_B);
            `ALU_CTRL_GEU:      ALUResult <= ALU_A >= ALU_B;
        
            default: begin 
                                ALUResult <= 32'bx; 
                                // $display("*** alu error ! ***%x", ALUCtrl); 
            end
        endcase
    end

endmodule