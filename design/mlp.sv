module mlp (
    input  logic        clk_i,
    input  logic        start_valid_i,
    output logic        start_ready_o,
    input  logic        init_valid_i,
    output logic        init_ready_o,
    input  logic [15:0] load_payload_i,
    output logic        result_valid_o,
    output logic [15:0] result_payload_o
);

    logic [35:0] partial_sum_reg;

endmodule
