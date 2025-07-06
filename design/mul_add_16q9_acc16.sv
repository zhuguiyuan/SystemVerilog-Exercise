module mul_add_16q9_acc16 (
    // 36 bits = 16 bits + 16 bits + $clog2(16) bits
    input  logic signed [15:0] a_i,
    input  logic signed [15:0] x_i,
    input  logic signed [35:0] b_i,
    output logic signed [15:0] y_sat_o,
    output logic signed [35:0] y_ori_o
);
    // mul and add
    assign y_ori_o = a_i * x_i + b_i;

    // round the decimal part
    logic signed carry_bit;
    assign carry_bit = y_ori_o[35] == 1'b1
                       ? y_ori_o[8]                      // positive
                       : (y_ori_o[8] & (|y_ori_o[7:0])); // negative

    // 28 bits = 1 bits + (4 biys + 7 bits + 7bits) + 9 bits
    logic signed [27:0] y_rnd;
    assign y_rnd = {y_ori_o[35], y_ori_o[35:9]} + 28'(carry_bit);

    // saturation the integer part
    localparam bit signed [15:0] max_value = {1'b0, {15{1'b1}}};
    localparam bit signed [15:0] min_value = {1'b1, {15{1'b0}}};
    assign y_sat_o = y_rnd[27] == 1'b0 && (|y_rnd[26:16]) == 1'b1
                     ? max_value
                     : y_rnd[27] == 1'b1 && (&y_rnd[26:16]) == 1'b0
                     ? min_value
                     : y_rnd[15:0];

endmodule
