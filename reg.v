module reg_with_enable #(parameter N = 31) (clk, rst, en, X, O);
input [N:0] X;
input clk;
input rst;
input en;
output [N:0] O;

reg [N:0] R;

always@(posedge clk) begin
    if (rst) begin
        R <= {N{1'b0}};
    end
    if (en) begin
        R <= X;
    end
end
assign O = R;
endmodule

module reg_module (reg1, reg2, clk, wr_reg, wr_data, reg_wr, reg1_val, reg2_val);

input [4:0] reg1;
input [4:0] reg2;

input [4:0] wr_reg;
input [31:0] wr_data;

input reg_wr;

output [31:0] reg1_val;
output [31:0] reg2_val;

reg [31:0] regfile [0:31];

always @(posedge clk) begin
    reg1_val <= regfile[reg1];
    reg2_val <= regfile[reg2];
end

always @(negedge clk) begin
    if (reg_wr) begin
        regfile[wr_reg] <= wr_data;
    end
end

endmodule

module flipflop #(N=32) (clk, rst, d, q);

input clk;
input rst;
input [N-1:0] d;
output [N-1:0] q;

reg [N-1:0] q;

always @(posedge clk) begin
    if (rst) q <= 0;
    else q <= d;  
end

endmodule

module data_memory (addr, wr_data, rd_data, wr_en, rd_en, clk, rst);

input [31:0] addr;
input [31:0] wr_data;
output [31:0] rd_data;
input wr_en;
input rd_en;
input clk;
input rst;

reg [31:0] mem [0:1023];

always @(posedge clk) begin
    if (rst) begin
        for (int i = 0; i < 1024; i = i + 1) begin
            mem[i] <= 0;
        end
    end
    if (rd_en) begin
        rd_data <= mem[addr];
    end
end

always @(negedge clk) begin
    if (wr_en) begin
        mem[addr] <= wr_data;
    end
end

endmodule

module instruction_memory(input [31:0] pc, output [31:0] instr);

reg [31:0] mem [0:1023];

initial begin
    $readmemh("instructions.txt", mem);
end

assign instr = mem[pc];

endmodule

module data_memory (addr, wr_data, rd_data, wr_en, clk, rst);

input [31:0] addr;
input [31:0] wr_data;
output [31:0] rd_data;
input wr_en;
input clk;
input rst;

reg [31:0] mem [0:1023];

always @(posedge clk) begin
    if (rst) begin
        for (int i = 0; i < 1024; i = i + 1) begin
            mem[i] <= 0;
        end
    end
    if (wr_en) begin
        mem[addr] <= wr_data;
    end
end

endmodule

module sign_extend (in, out);

input [15:0] in;
output [31:0] out;

assign out = {{16{in[15]}}, in};

endmodule

module adder (a, b, out);

input [31:0] a;
input [31:0] b;

output [31:0] out;

assign out = a + b;

endmodule

module sl2 (in, out);

input [31:0] in;
output [31:0] out;

assign out = in << 2;

endmodule

module mux2 (a, b, sel, out);

input [31:0] a;
input [31:0] b;

input sel;
output [31:0] out;

assign out = (sel) ? b : a;

endmodule