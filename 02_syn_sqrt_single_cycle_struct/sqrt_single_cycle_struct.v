module sqrt_single_cycle_struct
# (
    parameter DATA_WIDTH = 8
)
(
    input            clk,
    input            rst_n,
    input            arg_vld,
    input  [DATA_WIDTH - 1:0] arg,
    output           res_vld,
    output [DATA_WIDTH/2 - 1:0] res
);

    wire                      arg_vld_q;
    wire   [DATA_WIDTH - 1:0] arg_q;
    wire   [DATA_WIDTH/2 - 1:0] res_d;

    reg_rst_n                 i_arg_vld (clk, rst_n, arg_vld, arg_vld_q);
    reg_no_rst # (DATA_WIDTH) i_arg     (clk, arg, arg_q);

    wire                      res_vld_d = arg_vld_q;

    assign res_d[3] = arg_q[7:6] == 2'b00 ? 1'b0 : 1'b1;
    assign res_d[2] = arg_q[7:4] < {res_d[3], 1'b1} * {res_d[3], 1'b1} ? 1'b0 : 1'b1;
    assign res_d[1] = arg_q[7:2] < {res_d[3:2], 1'b1} * {res_d[3:2], 1'b1} ? 1'b0 : 1'b1;
    assign res_d[0] = arg_q[7:0] < {res_d[3:1], 1'b1} * {res_d[3:1], 1'b1} ? 1'b0 : 1'b1;

    reg_rst_n                 i_res_vld (clk, rst_n, res_vld_d, res_vld);
    reg_no_rst # (DATA_WIDTH/2) i_res     (clk, res_d, res);

endmodule
