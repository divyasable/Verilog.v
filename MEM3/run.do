vlib work
vlog mem_tb2.v
vsim mem_tb +testcase=ONE_WRITE
add wave -r sim:/mem_tb/dut/*
#do wave.do
run -all

