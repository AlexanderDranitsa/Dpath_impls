module sqrt_pipe_cycle_struct
# (
    parameter DATA_WIDTH = 8
)
(
    input                           clk,
    input                           rst_n,
    input                           arg_vld,
    input  [DATA_WIDTH - 1:0]       arg,
    output                          res_vld,
    output [DATA_WIDTH/2 - 1:0]     res
);

    wire                      arg_vld_q_1;
    wire [DATA_WIDTH - 1:0]   arg_q_1;
    wire [DATA_WIDTH/2 - 1:0] res_d;

    reg_no_rst # (DATA_WIDTH) i0_arg     (clk, arg, arg_q_1);

    // ------------- STAGE 1

    wire com_d_1 = arg_q_1[7:6] == 2'b00 ? 1'b0 : 1'b1;
    wire [DATA_WIDTH - 1:0]   arg_q_2;
    wire com_q_2;
    wire [DATA_WIDTH/2 - 1:0] res_d_1;
    assign res_d[3] = com_d_1;

    reg_no_rst # (DATA_WIDTH) i1_arg ( clk, arg_q_1, arg_q_2 );
    reg_no_rst # (1)          i1_com ( clk, com_d_1, com_q_2 );
    reg_no_rst # (4)          i1_res ( clk, res_d  , res_d_1 );

    // ------------- STAGE 2

    wire [3:0] mul_d_1 = {com_q_2, 1'b1} * {com_q_2, 1'b1};
    wire [DATA_WIDTH - 1:0]   arg_q_3;
    wire [DATA_WIDTH/2 - 1:0] res_d_2;
    wire [3:0] mul_d_2;
    wire com_q_3;
    
    reg_no_rst # (DATA_WIDTH) i2_arg ( clk, arg_q_2, arg_q_3 );
    reg_no_rst # (1)          i2_com ( clk, com_q_2, com_q_3 );
    reg_no_rst # (4)          i2_mul ( clk, mul_d_1, mul_d_2 );
    reg_no_rst # (4)          i2_res ( clk, res_d_1, res_d_2 );

    // ------------- STAGE 3

    wire com_d_2 = arg_q_3[7:4] < mul_d_2 ? 1'b0 : 1'b1;
    wire [DATA_WIDTH - 1:0]   arg_q_4;
    wire [DATA_WIDTH/2 - 1:0] res_d_3;

    reg_no_rst # (DATA_WIDTH) i3_arg ( clk, arg_q_3, arg_q_4 );
    reg_no_rst # (4)          i3_res ( clk, { res_d_2[3], com_d_2, 2'b00 }, res_d_3 );

    // ------------- STAGE 4

    wire [5:0] mul_d_3 = {res_d_3[3:2], 1'b1} * {res_d_3[3:2], 1'b1};
    wire [5:0] mul_d_4;
    wire [DATA_WIDTH - 1:0]   arg_q_5;
    wire [DATA_WIDTH/2 - 1:0] res_d_4;

    reg_no_rst # (DATA_WIDTH) i4_arg ( clk, arg_q_4, arg_q_5 );
    reg_no_rst # (4)          i4_res ( clk, res_d_3, res_d_4 );
    reg_no_rst # (6)          i4_mul ( clk, mul_d_3, mul_d_4 );

    // ------------- STAGE 5

    wire com_d_3 = arg_q_5[7:2] < mul_d_4 ? 1'b0 : 1'b1;
    wire [DATA_WIDTH - 1:0]   arg_q_6;
    wire [DATA_WIDTH/2 - 1:0] res_d_5;

    reg_no_rst # (DATA_WIDTH) i5_arg ( clk, arg_q_5, arg_q_6 );
    reg_no_rst # (4)          i5_res ( clk, { res_d_4[3:2], com_d_3, 1'b0 }, res_d_5 );

    // ------------- STAGE 6

    wire [DATA_WIDTH - 1:0] mul_d_5 = {res_d_5[3:1],1'b1} * {res_d_5[3:1],1'b1};
    wire [DATA_WIDTH - 1:0] mul_d_6;
    wire [DATA_WIDTH - 1:0]   arg_q_7;
    wire [DATA_WIDTH/2 - 1:0] res_d_6;

    reg_no_rst # (DATA_WIDTH) i6_arg ( clk, arg_q_6, arg_q_7 );
    reg_no_rst # (4)          i6_res ( clk, res_d_5, res_d_6 );
    reg_no_rst # (DATA_WIDTH) i6_mul ( clk, mul_d_5, mul_d_6 );

    // ------------- STAGE 7

    wire com_d_4 = arg_q_7[7:0] < mul_d_6 ? 1'b0 : 1'b1;
    wire [DATA_WIDTH/2 - 1:0] res_d_7;

    reg_no_rst # (4)          i7_res ( clk, { res_d_6[3:1], com_d_4 }, res_d_7 );
    reg_no_rst # (4)          i8_res ( clk, res_d_7, res );

endmodule
