vcom -93 Register.vhdl
vcom -93 BufferMemory.vhdl
vsim MemBufferEnt
add wave -position end sim:/membufferent/*
force -freeze sim:/membufferent/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/membufferent/Reset 0 0
force -freeze sim:/membufferent/Enable 1 0

force -freeze sim:/membufferent/SP 00000000000000000000000000000001 0
force -freeze sim:/membufferent/ControlSignals 00000000000000000000000000000010 0
force -freeze sim:/membufferent/MemOut 00000000000000000000000000000011 0
force -freeze sim:/membufferent/ALUResult 00000000000000000000000000000100 0
run 
force -freeze sim:/membufferent/SP 00000000000000000000000000000010 0
force -freeze sim:/membufferent/ControlSignals 00000000000000000000000000000100 0
force -freeze sim:/membufferent/MemOut 00000000000000000000000000001001 0
force -freeze sim:/membufferent/ALUResult 00000000000000000000000000010000 0
run 
force -freeze sim:/membufferent/SP 00000000000000000000000000000001 0
force -freeze sim:/membufferent/ControlSignals 00000000000000000000000000000010 0
force -freeze sim:/membufferent/MemOut 00000000000000000000000000000011 0
force -freeze sim:/membufferent/ALUResult 00000000000000000000000000000100 0
run
