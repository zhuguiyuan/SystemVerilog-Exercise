module mul_add_16q9_acc16 (
    input  logic signed [15:0] a_i,
    input  logic signed [15:0] x_i,
    input  logic signed [35:0] b_i,
    output logic signed [15:0] y_sat_o,
    output logic signed [35:0] y_ori_o
);

    assign y_ori_o = a_i * x_i + b_i;

    logic [17:0] integer_part = y_ori_o[17: 0];
    logic [18:0] decimal_part = y_ori_o[35:18];

endmodule
