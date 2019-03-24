module sqrt_multi_cycle_struct
# (
    parameter DATA_WIDTH = 8
)
(
    input                         clk,
    input                         rst_n,
    input                         arg_vld,
    input  [DATA_WIDTH   - 1:0]   arg,
    output                        res_vld,
    output [DATA_WIDTH/2 - 1:0]   res
);

    wire                          arg_vld_q;
    wire   [DATA_WIDTH   - 1:0]   arg_q;
    wire   signed [DATA_WIDTH   - 1:0]   r_mask_1;
    wire   signed [DATA_WIDTH   - 1:0]   r_mask_2;    
    wire   [DATA_WIDTH   - 1:0]   w_tmp = arg_q & r_mask_2;
    wire   [DATA_WIDTH/2 - 1:0]   r_ans_mask_1;
    wire   [DATA_WIDTH/2 - 1:0]   r_ans_mask_2;
    wire   [DATA_WIDTH/2 - 1:0]   r_ans_1;
    wire   [DATA_WIDTH/2 - 1:0]   r_ans_2;
    wire   [DATA_WIDTH   - 1:0]   w_ans2 = r_ans_2 * r_ans_2;
    wire   [1:0]                  cnt_1;
    wire   [1:0]                  cnt_2 = arg_vld_q ? 2'b00 : cnt_1 + 1;
    wire   [DATA_WIDTH/2 - 1:0]   r_out_1;
    wire   [DATA_WIDTH/2 - 1:0]   r_out_2;

    reg_rst_n                     i_arg_vld   (clk, rst_n, arg_vld, arg_vld_q);
    reg_no_rst_en #(DATA_WIDTH)   i_arg       (clk, arg_vld, arg, arg_q);  
    reg_no_rst    #(DATA_WIDTH)   i_mask      (clk, r_mask_1, r_mask_2);
    reg_no_rst    #(DATA_WIDTH/2) i_ans_mask  (clk, r_ans_mask_1, r_ans_mask_2);
    reg_no_rst    #(DATA_WIDTH/2) i_ans       (clk, r_ans_1, r_ans_2);
    reg_rst_n     #(2)            i_cnt       (clk, rst_n, cnt_2, cnt_1);
    reg_no_rst    #(DATA_WIDTH/2) i_res       (clk, r_out_1, r_out_2);

    assign { r_out_1, r_mask_1, r_ans_1, r_ans_mask_1 } = arg_vld_q ? { 4'b0000, 8'b0000_0000, 4'b0000, 4'b0000} : (cnt_1 == 2'b00 ? 
           ( w_ans2 > w_tmp ? { r_ans_2 ^ r_ans_mask_2, 8'b1100_0000, 4'b1000, 4'b1000}  : 
                              { r_ans_2,                8'b0000_0000, 4'b1000, 4'b1000}) : 
           ( w_ans2 > w_tmp ? { r_out_2, r_mask_2 >>> 2, r_ans_2 ^ (r_ans_mask_2 >> 1) ^ r_ans_mask_2, r_ans_mask_2 >> 1} :
                              { r_out_2, r_mask_2 >>> 2, r_ans_2 ^ (r_ans_mask_2 >> 1)               , r_ans_mask_2 >> 1}));
    assign res = r_out_2;

endmodule