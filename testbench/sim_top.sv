module sim_top ();
    logic        clk_i;
    logic        rst_ni;
    logic        start_valid_i;
    logic        start_ready_o;
    logic        init_valid_i;
    logic        init_ready_o;
    logic [15:0] load_payload_i;
    logic        result_valid_o;
    logic [15:0] result_payload_o;
    
    mlp top (.*);
    
    initial begin clk_i = 0; forever #1 clk_i = ~clk_i; end

    always begin
        rst_ni <= 0;
        start_valid_i <=0;
        init_valid_i <= 0;
        repeat(10) @(posedge clk_i);
        rst_ni <= 1;
        repeat(10) @(posedge clk_i);
        init_valid_i <= 1;

        $finish();
    end

endmodule
