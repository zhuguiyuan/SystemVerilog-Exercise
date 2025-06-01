module mlp_fsm (
    input  logic        clk_i,

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

    logic [2:0] cnt_layer_reg;
    logic [3:0] cnt_16_reg;
    logic [7:0] cnt_mut_reg;

    typedef enum logic [4:0] {Idle, InitW, LoadX, Acc, Wb, StoreX} state_t;

    state_t state_reg, state_next;

    always_ff @(posedge clk_i) begin
    end

endmodule
