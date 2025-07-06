module mlp (
    input  logic        clk_i,
    input  logic        rst_ni,

    input  logic        start_valid_i,
    output logic        start_ready_o,
    input  logic        init_valid_i,
    output logic        init_ready_o,
    input  logic [15:0] load_payload_i,
    output logic        result_valid_o,
    output logic [15:0] result_payload_o
);

    logic [10:0] w_addr;
    logic [ 7:0] x_addr;
    logic        w_ren;
    logic        w_wen;
    logic        x_ren;
    logic        x_wen;
    logic        x_sel;
    logic        partial_sum_store;
    logic        x_sram_write_back;

    mlp_fsm u_fsm (
        .clk_i               (clk_i            ),
        .rst_ni              (rst_ni           ),
        .start_valid_i       (start_valid_i    ),
        .start_ready_o       (start_ready_o    ),
        .init_valid_i        (init_valid_i     ),
        .init_ready_o        (init_ready_o     ),
        .result_valid_o      (result_valid_o   ),
        .w_ren_o             (w_ren            ),
        .w_wen_o             (w_wen            ),
        .w_addr_o            (w_addr           ),
        .x_ren_o             (x_ren            ),
        .x_wen_o             (x_wen            ),
        .x_sel_o             (x_sel            ),
        .x_addr_o            (x_addr           ),
        .partial_sum_store_o (partial_sum_store),
        .x_sram_write_back_o (x_sram_write_back)
    );

    logic [15:0] w_sram_q, x_sram_q;
    logic [15:0] complete_sum_reg, y_sat;
    logic [35:0] partial_sum_reg, y_ori;

    mul_add_16q9_acc16 u_calc (
        .a_i     (w_sram_q       ),
        .x_i     (x_sram_q       ),
        .b_i     (partial_sum_reg),
        .y_sat_o (y_sat          ),
        .y_ori_o (y_ori          )
    );

    always_ff @(posedge clk_i) begin
        if (!rst_ni | x_sram_write_back) begin
            partial_sum_reg <= '0;
            complete_sum_reg <= '0;
        end else if (partial_sum_store) begin
            partial_sum_reg <= y_ori;
            complete_sum_reg <= y_sat;
        end
    end

    logic [15:0] w_sram_d;
    logic        w_men;
    sramSpw2048d16 u_w_sram (
        .Q   (w_sram_q),
        .ADR (w_addr  ),
        .D   (w_sram_d),
        .WE  (w_wen   ),
        .ME  (w_men   ),
        .clk (clk_i   )
    );
    assign w_sram_d = load_payload_i;
    assign w_men = w_wen | w_ren;

    logic [15:0] x_sram_d;
    logic [ 8:0] x_taddr;
    logic        x_men;
    sramSpw512d16 u_x_sram (
        .Q   (x_sram_q),
        .ADR (x_taddr ),
        .D   (x_sram_d),
        .WE  (x_wen   ),
        .ME  (x_men   ),
        .clk (clk_i   )
    );

    assign x_sram_d = x_sram_write_back == 1'b1
                      ? complete_sum_reg : load_payload_i;
    assign x_taddr = {x_sel, x_addr};
    assign x_men = x_wen | x_ren;
    assign result_payload_o = x_sram_q;

endmodule
