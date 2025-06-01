module mlp (
    input  logic        clk,
    input  logic        start_valid,
    output logic        start_ready,
    input  logic        init_valid,
    output logic        init_ready,
    input  logic [15:0] load_payload,
    output logic        result_valid,
    output logic [15:0] result_payload,
);
endmodule