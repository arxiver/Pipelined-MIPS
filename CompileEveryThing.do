############################### Control unit ####################################
vcom -93 control_unit.vhd

############################### Decode Stage ####################################
vcom -93 register.vhd
vcom -93 sign_extend.vhd
vcom -93 zero_extend.vhd
vcom -93 register_file.vhd
vcom -93 decode_stage.vhd

############################### Fetch Buffer ####################################
vcom -93 fetch_buffer.vhd

############################### Fetch Stage ######################################
vcom -93 ins_ram.vhd
vcom -93 fetch_stage.vhd

############################## ID_EX #############################################
vcom -93 ID_EX.vhd

##################################### Execute ####################################
vcom -93 my_adder.vhd
vcom -93 my_nadder.vhd
vcom -93 ALU_PortA.vhd
vcom -93 ALU_PortB.vhd
vcom -93 ALU.vhd
vcom -93 ALU_Src1_MUX.vhd
vcom -93 ALU_Src2_MUX.vhd
vcom -93 Execute_Stage.vhd

####################################### EX_Buffer #################################
vcom -93 EX_Buffer.vhd

############################## Memory Stage #######################################
vcom -93 Mux21.vhdl
vcom -93 Mux41.vhdl
vcom -93 Ram.vhdl
vcom -93 MemoryStage.vhdl

############################### MemoryBuffer #####################################
vcom -93 Register.vhdl
vcom -93 BufferMemory.vhdl

############################### WB Stage #########################################
vcom -93 WBStage.vhdl

############################### Tri State #########################################
vcom -93 TriState.vhdl
vcom -93 TriStateSP.vhdl


##################################### Main ########################################
vcom -93 _CPU_MAIN.vhd

###################################### VISM ########################################
vsim CPU_MAIN

#################################### Sofyan Test ####################################

add wave -position end  sim:/cpu_main/WB_WR_ADDRESS_1
add wave -position end  sim:/cpu_main/WB_WR_ADDRESS_2
add wave -position end  sim:/cpu_main/WB_WR_DATA_1
add wave -position end  sim:/cpu_main/WB_WR_DATA_2
add wave -position end  sim:/cpu_main/WB_WR_EN_1
add wave -position end  sim:/cpu_main/WB_WR_EN_2
add wave -position end  sim:/cpu_main/WB_SWAP_EN
add wave -position end  sim:/cpu_main/RDesDataOutMemory
add wave -position end  sim:/cpu_main/RSrc2DataOutMemory
add wave -position end  sim:/cpu_main/RDesOutMemory
add wave -position end  sim:/cpu_main/RSrcOut1Memory
add wave -position end  sim:/cpu_main/RSrcOut2Memory
add wave -position end  sim:/cpu_main/MemOutMemory
add wave -position end  sim:/cpu_main/SPOutMemory
add wave -position end  sim:/cpu_main/ALUResultOutMemory
add wave -position end  sim:/cpu_main/ControlSignalsOutMemory
add wave -position end  sim:/cpu_main/RDesDataOutBuffer
add wave -position end  sim:/cpu_main/RSrc2DataOutBuffer
add wave -position end  sim:/cpu_main/RDesOutBuffer
add wave -position end  sim:/cpu_main/RSrcOut1Buffer
add wave -position end  sim:/cpu_main/RSrcOut2Buffer
add wave -position end  sim:/cpu_main/ControlSignalsOutBuffer
add wave -position end  sim:/cpu_main/SPOutBuffer
add wave -position end  sim:/cpu_main/MemOutBuffer
add wave -position end  sim:/cpu_main/ALUResultOutBuffer
add wave -position end  sim:/cpu_main/RDesDataOutWB
add wave -position end  sim:/cpu_main/RSrc2DataOutWB
add wave -position end  sim:/cpu_main/RDesOutWB
add wave -position end  sim:/cpu_main/RSrcOut1WB
add wave -position end  sim:/cpu_main/RSrcOut2WB
add wave -position end  sim:/cpu_main/ControlSignalsOutWB
add wave -position end  sim:/cpu_main/Mux10OutWB
add wave -position end  sim:/cpu_main/SPOutWB
add wave -position end  sim:/cpu_main/IntOutWB
add wave -position end  sim:/cpu_main/CLK
force -freeze sim:/cpu_main/CLK 1 0, 0 {50 ps} -r 100

