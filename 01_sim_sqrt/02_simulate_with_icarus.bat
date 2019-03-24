
rem recreate a temp folder for all the simulation files

rd /s /q sim
md sim
cd sim

rem compile verilog files for simulation

iverilog -o sqrt ../../common/reg*.v ../../*/sqrt*.v ../testbench.v

rem run the simulation and finish on $stop

vvp sqrt

rem show the simulation results in GTKwave

gtkwave testbench.vcd

rem return to the parent folder

cd ..
