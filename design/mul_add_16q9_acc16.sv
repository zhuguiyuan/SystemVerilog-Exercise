module mul_add_16q9_acc16 (
    input  signed logic [15:0] a_i,
    input  signed logic [15:0] x_i,
    input  signed logic [35:0] b_i,
    output signed logic [15:0] y_sat_o,
    output signed logic [35:0] y_ori_o
);

    assign y_ori = a * x + b;

    logic integer_part = y_ori[17: 0];
    logic decimal_part = y_ori[35:18];

endmodule
