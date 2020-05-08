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

############################### WB Stage #####################################
vcom -93 WBStage.vhdl



##################################### Main ########################################
vcom -93 _CPU_MAIN.vhd

###################################### VISM ########################################
vsim CPU_MAIN

