module alu (a, b, alu_op, alu_out, zero);

input [31:0] a;
input [31:0] b;

input [2:0] alu_op;

output [31:0] alu_out;

output zero;

assign aluout = (alu_op == 3'b010) ? a + b : 
                (alu_op == 3'b110) ? a - b : 
                (alu_op == 3'b110) ? a & b : 
                (alu_op == 3'b001) ? a | b :
                (alu_op == 4'b111) ? a << b : 0;

assign zero = (aluout == 0) ? 1 : 0;

endmodule