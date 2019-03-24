FILE = sqrt_pipe_cycle_struct.v testbench.v ../common/reg*.v

all: comp vvp #gtk

comp:
	iverilog -o sqrt $(FILE)
vvp:
	vvp sqrt
gtk:
	gtkwave testbench.vcd