module sramSpw2048d16 (
    output logic [15:0] Q,
    input  logic [10:0] ADR,
    input  logic [15:0] D,
    input  logic        WE,
    input  logic        ME,
    input  logic        clk
);

  logic [15:0] Q0, Q1;
  logic [9:0] INNER_ADR;
  logic       INNER_SEL;
  assign INNER_ADR = ADR[9:0];
  assign INNER_SEL = ADR[10];

  sramSpw1024d16 u0 (
    .Q   	(Q0            ),
    .ADR 	(INNER_ADR     ),
    .D   	(D             ),
    .WE  	(WE & INNER_SEL),
    .ME  	(ME & INNER_SEL),
    .clk 	(clk           )
  );

  sramSpw1024d16 u1 (
    .Q   	(Q1            ),
    .ADR 	(INNER_ADR     ),
    .D   	(D             ),
    .WE  	(WE & INNER_SEL),
    .ME  	(ME & INNER_SEL),
    .clk 	(clk           )
  );

  assign Q = INNER_SEL == 1'b0 ? Q0 : Q1;

endmodule
