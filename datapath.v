module datapath (clk, rst, reg_dst, req_wr, alu_op, mem_wr, mem_rd, alusrc, mem2reg, branch, jr, jump);

input clk;
input rst;

input reg_dst;
input req_wr;
input [2:0] alu_op;
input mem_wr;
input mem_rd;
input alusrc;
input mem2reg;
input branch;
input jr;
input jump;

wire [31:0] pc;
wire [31:0] instr;
wire [31:0] pc_next;

wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;

wire [4:0] reg1;
wire [4:0] reg2;
wire [15:0] imm;
wire [25:0] jump_addr;

wire [31:0] wr_data;
wire [4:0] wr_reg;
wire reg_wr;
wire [31:0] reg1_val;
wire [31:0] reg2_val;
wire [31:0] aluout;

assign rs = instr[25:21];
assign rt = instr[20:16];
assign rd = instr[15:11];
assign imm = instr[15:0];
assign jump_addr = instr[25:0];

assign reg1 = rs;
assign reg2 = (reg_dst) ? rt : rd;

flipflop #(32) pc_reg (.clk(clk), .rst(rst), .d(pc), .q(pc_next));

instruction_memory instr_mem (.pc(pc), .instr(instr));

reg_module reg_file (.reg1(reg1), .reg2(reg2), .clk(clk), .rst(rst), .wr_reg(wr_reg), .wr_data(wr_data), .reg_wr(reg_wr), .reg1_val(reg1_val), .reg2_val(reg2_val));

mux2 #(5) reg_dst (rd, rt, reg_dst, wr_reg);

wire [31:0] sign;

sign_extend #(16) imm_gen (imm, sign);

mux2 #(32) alu_src (reg2_val, sign, alusrc, wr_data);

alu alu_inst (.a(reg1_val), .b(wr_data), .alu_op(alu_op), .alu_out(aluout), .zero(zero));

data_memory data_mem (.addr(aluout), .wr_data(reg2_val), .rd_data(rd_data), .wr_en(mem_wr), .clk(clk), .rst(rst));

mux2 #(32) mem2reg_mux (aluout, rd, mem2reg, wr_data);

reg_module reg_inst (.reg1(reg1), .reg2(reg2), .clk(clk), .rst(rst), .wr_reg(wr_reg), .wr_data(wr_data), .reg_wr(reg_wr), .reg1_val(reg1_val), .reg2_val(reg2_val));

endmodule