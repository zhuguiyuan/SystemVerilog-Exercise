module mul_add_unit #(
    paramater WIDTH = 16
    paramater MAXN  = 16
) (
    input  signed logic [                  WIDTH - 1 : 0] a_i,
    input  signed logic [                  WIDTH - 1 : 0] x_i,
    input  signed logic [2 * WIDTH + $clog(MAXN) - 1 : 0] b_i,
    output signed logic [                  WIDTH - 1 : 0] y_sat_o,
    output signed logic [2 * WIDTH + $clog(MAXN) - 1 : 0] y_ori_o
);

    assign y_ori = a * x + b;

    logic integer_part = y_ori[17: 0];
    logic decimal_part = y_ori[35:18];

endmodule
