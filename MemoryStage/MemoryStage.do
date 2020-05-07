vcom -93 Ram.vhdl
vcom -93 Mux21.vhdl
vcom -93 Mux41.vhdl
vcom -93 MemoryStage.vhdl
vsim memoryent
add wave -position end sim:/memoryent/*
force -freeze sim:/memoryent/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/memoryent/ALUResult 00000000000000000000000000000000 0
force -freeze sim:/memoryent/SPSignal 0 0
force -freeze sim:/memoryent/Int 0 0
force -freeze sim:/memoryent/IncrementOrDecrement 0 0
force -freeze sim:/memoryent/SP 00000000000000000000000000000000 0
force -freeze sim:/memoryent/Call 0 0
force -freeze sim:/memoryent/DataRead2 00000000000000000000000000001010 0
force -freeze sim:/memoryent/MemW 1 0
force -freeze sim:/memoryent/MemR 0 0
force -freeze sim:/memoryent/Enable 1 0
run
run