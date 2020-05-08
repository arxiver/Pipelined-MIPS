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

############################## Memory Stage #######################################
vcom -93 Mux21.vhdl
vcom -93 Mux41.vhdl
vcom -93 Ram.vhdl
vcom -93 MemoryStage.vhdl

############################### MemoryBuffer #####################################
vcom -93 Register.vhdl
vcom -93 BufferMemory.vhdl

############################### WB Stage #####################################
vcom -93 WBStage.vhdl

##################################### Main ########################################
vcom -93 _CPU_MAIN.vhd

###################################### VISM ########################################
vsim CPU_MAIN

