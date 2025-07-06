module sramSpw1024d16 (
    output wire [15:0] Q,
    input  wire [ 9:0] ADR,
    input  wire [15:0] D,
    input  wire        WE,
    input  wire        ME,
    input  wire        clk
);
  reg [15:0] tmp_Q;
  reg [15:0] sramSp[0:1023];

  always @(posedge clk) begin
    if (ME) begin
      tmp_Q <= sramSp[ADR];
    end
    if (ME && WE) begin
      sramSp[ADR] <= D;
    end
  end

  assign Q = tmp_Q;

endmodule
