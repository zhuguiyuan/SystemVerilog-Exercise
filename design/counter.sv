module counter #(
    parameter  int  Limit = 16,
    localparam byte Width = $clog2(Limit)
) (
    input  logic             clk_i,
    input  logic             rst_ni,
    input  logic             inc_i,
    input  logic             clr_i,
    output logic [Width-1:0] value_o,
    output logic             will_overflow_o
);
    logic [Width:0] value_reg, value_next, value_inc;

    always_ff @(posedge clk_i) begin
        if (!rst_ni) begin
            value_reg <= 0;
        end else begin
            value_reg <= value_next;
        end
    end

    assign value_inc = value_reg + 1;

    always_comb begin
        if (clr_i) begin
            value_next = '0;
        end else if (inc_i) begin
            if (will_overflow_o) begin
                value_next = '0;
            end else begin
                value_next = value_inc;
            end
        end
    end

    assign will_overflow_o = value_inc == Limit;

endmodule