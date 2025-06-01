module sim_top ();
    timeunit 1ns/1ns;
    reg clk;
    initial begin
        clk <= 0;
        forever #1 clk = ~clk;
    end

    initial begin
    end
endmodule
