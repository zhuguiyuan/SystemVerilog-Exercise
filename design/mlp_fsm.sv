module mlp_fsm (
    input  logic        clk_i,
    input  logic        rst_ni,

    input  logic        start_valid_i,
    output logic        start_ready_o,
    input  logic        init_valid_i,
    output logic        init_ready_o,
    output logic        result_valid_o,

    output logic        w_ren_o,
    output logic        w_wen_o,
    output logic [10:0] w_addr_o,
    output logic        x_ren_o,
    output logic        x_wen_o,
    output logic        x_sel_o,
    output logic [ 7:0] x_addr_o,
);

    // layer counter from 0 to 7
    logic       cnt_layer_inc;
    logic       cnt_layer_clr;
    logic [2:0] cnt_layer_value;
    logic       cnt_layer_will_overflow
    counter #(.Limit(8)) cnt_layer (
        .clk_i           (clk_i),
        .rst_ni          (rst_ni),
        .inc_i           (cnt_layer_inc),
        .clr_i           (cnt_layer_clr),
        .value_o         (cnt_layer_value),
        .will_overflow_o (cnt_layer_will_overflow)
    );

    // 16 counter from 0 to 15
    logic       cnt_16_inc;
    logic       cnt_16_clr;
    logic [3:0] cnt_16_value;
    logic       cnt_16_will_overflow
    counter #(.Limit(16)) cnt_16 (
        .clk_i           (clk_i),
        .rst_ni          (rst_ni),
        .inc_i           (cnt_16_inc),
        .clr_i           (cnt_16_clr),
        .value_o         (cnt_16_value),
        .will_overflow_o (cnt_16_will_overflow)
    );

    // mut counter from 0 to 16 * 16 - 1
    logic       cnt_mut_inc;
    logic       cnt_mut_clr;
    logic [7:0] cnt_mut_value;
    logic       cnt_mut_will_overflow
    counter #(.Limit(16*16)) cnt_mut (
        .clk_i           (clk_i),
        .rst_ni          (rst_ni),
        .inc_i           (cnt_mut_inc),
        .clr_i           (cnt_mut_clr),
        .value_o         (cnt_mut_value),
        .will_overflow_o (cnt_mut_will_overflow)
    );

    typedef enum logic [4:0] {Idle, InitW, LoadX, Acc, Wb, StoreX} state_t;

    state_t state_reg, state_next;

    always_ff @(posedge clk_i) begin
        if (!rst_ni) begin
            state_reg <= Idle;
        end else begin
            state_reg <= state_next;
        end
    end

    always_comb begin: state_trans
        state_next = state_reg;
        case (state_reg)
            Idle: begin
                if (init_valid_i) begin
                    state_next = InitW;
                end else if (start_valid_i) begin
                    state_next = LoadX;
                end
            end
            InitW: begin
                if (cnt_layer_will_overflow
                    && cnt_mut_will_overflow) begin
                    state_next = Idle;
                end
            end
            LoadX: begin
                if (cnt_mut_will_overflow) begin
                    state_next = Acc;
                end
            end
            Acc: begin
                if (cnt_16_will_overflow) begin
                    state_next = Wb;
                end
            end
            Wb: begin
                if (cnt_layer_will_overflow
                   && cnt_mut_will_overflow) begin
                    state_next = StoreX;
                end else begin
                    state_next = Acc;
                end
            end
            StoreX: begin
                if (cnt_mut_will_overflow) begin
                end
            end
        endcase
    end

endmodule
