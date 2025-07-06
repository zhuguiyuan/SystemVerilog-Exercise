module sim_fsm ();
    logic        clk_i;
    logic        rst_ni;
    logic        start_valid_i;
    logic        start_ready_o;
    logic        init_valid_i;
    logic        init_ready_o;
    logic        result_valid_o;
    logic        w_ren_o;
    logic        w_wen_o;
    logic [10:0] w_addr_o;
    logic        x_ren_o;
    logic        x_wen_o;
    logic        x_sel_o;
    logic [ 7:0] x_addr_o;
    logic        partial_sum_store_o;
    logic        x_sram_write_back_o;

    mlp_fsm fsm(.*);

    initial begin clk_i = 0; forever #1 clk_i = ~clk_i; end

    always begin
        rst_ni <= 0;
        start_valid_i <=0;
        init_valid_i <= 0;
        repeat(10) @(posedge clk_i);
        rst_ni <= 1;
        repeat(10) @(posedge clk_i);
        init_valid_i <= 1;
        @(posedge clk_i);
        init_valid_i <= 0;
        @(posedge clk_i) wait (start_ready_o);
        start_valid_i <= 1;
        @(posedge clk_i);
        start_valid_i <= 0;
        @(posedge clk_i) wait (start_ready_o);
        repeat(10) @(posedge clk_i);
        $finish();
    end

    initial begin
        $dumpfile("demo.vcd");
        $dumpvars();
    end

endmodule
