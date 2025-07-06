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

    logic signed [15:0] weights [0:2047];
    logic signed [15:0] inputs[0:255];
    logic signed [15:0] gold_outputs[0:255];
    logic signed [15:0] real_outputs[0:255];

    always begin
        $readmemb("testbench/testcase/Weight.txt", weights);
        $readmemb("testbench/testcase/Input.txt", inputs);
        $readmemb("testbench/testcase/Output.txt", gold_outputs);

        rst_ni <= 0;
        start_valid_i <=0;
        init_valid_i <= 0;
        repeat(10) @(posedge clk_i);
        rst_ni <= 1;
        repeat(10) @(posedge clk_i);
        init_valid_i <= 1;
        @(posedge clk_i);
        init_valid_i <= 0;
        for(int i = 0; i < 2048; ++i) begin
            load_payload_i <= weights[i];
            @(posedge clk_i);
        end
        wait(start_ready_o);
        start_valid_i <= 1;
        @(posedge clk_i);
        start_valid_i <= 0;
        for (int i = 0; i < 256; ++i) begin
            load_payload_i <= inputs[i];
            @(posedge clk_i);
        end
        wait(result_valid_o);
        for (int i = 0; i < 256; ++i) begin
            // saddly verilator does't support NBA to array in for loop
            // but it's ok to sample the value before posedge of clk_i with BA
            @(posedge clk_i)
            real_outputs[i] = result_payload_o;
        end
        @(posedge clk_i);
        $display("Checking Results");
        for (int i = 0; i < 256; ++i) begin
            if (real_outputs[i] == gold_outputs[i]) begin
                $display("Pass %d", i);
            end else begin
                $display("Error %d, want %d, but got %d",
                         i, gold_outputs[i], real_outputs[i]);
            end
        end
        $finish();
    end

    initial begin
        $dumpfile("demo.vcd");
        $dumpvars();
    end

endmodule
