VSRCS = design/counter.sv \
		design/sramSpw2048d16.sv \
		design/mlp_fsm.sv \
		design/sramSpw512d16.v \
		design/mul_add_16q9_acc16.sv \
		design/mlp.sv \
		design/sramSpw1024d16.v

sta:
	make -C $(STA_HOME) O=$(PWD) DESIGN=mlp CLK_PORT_NAME=clk_i \
		RTL_FILES="$(realpath $(VSRCS))" sta

.PHONY: sta

