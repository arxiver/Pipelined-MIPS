

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_STD.ALL;

entity Forwarding_Unit_Entity is 
port(
EX_MEM_Rdst_Address,
MEM_WB_Rdst_Address,
ALU_Rsrc1_Address,
ALU_Rsrc2_Address: in std_logic_vector (2 downto 0);

EX_MEM_OPCODE,
MEM_WB_OPCODE,
ALU_OPCODE : in std_logic_vector(4 downto 0);

Rsrc1_Selector,
Rsrc2_Selector : out std_logic_vector(1 downto 0)

);
end entity Forwarding_Unit_Entity;


architecture Forwarding_Unit_Arch of Forwarding_Unit_Entity is
    
    signal Src1_Read_After_Write_Hazard_MEM,
           Src1_Read_After_Write_Hazard_WB,
           Src1_Read_After_Mem_Hazard_WB,
           Src2_Read_After_Write_Hazard_MEM,
           Src2_Read_After_Write_Hazard_WB,
           Src2_Read_After_Mem_Hazard_WB,
           ALU_OPCODE_READ_OP,  --if = 1 -> it means that in this op code there is no read operation
           MEM_OPCODE_WR_OP: std_logic; --if = 1 -> it means that in this op code there is no write operation
    
    signal WB_OPCODE_WR_MEM_OP : std_logic_vector(1 downto 0); -- 0 -> no MEM or WR op
                                                                -- 1 -> WR op
                                                                --2 -> MEM op

    Begin
    

    --Checking ALU OPCODE FOR READ OPERATIONS
    ---------------------------------------------------------------------------------------------------------------------
    ALU_OPCODE_READ_OP <= '0' 
    when ALU_OPCODE = "00101" OR ALU_OPCODE = "00000" OR ALU_OPCODE = "10001" OR  ALU_OPCODE = "10010" 
     OR  ALU_OPCODE = "10011" OR  ALU_OPCODE = "11000" OR ALU_OPCODE = "11001" 
     OR  ALU_OPCODE = "11011" OR  ALU_OPCODE = "11100" 
    else '1';
    --------------------------------------------------------------------------------------------------------------------	

    --Checking MEM OPCODE FOR WRITE OPERATIONS (No memory operations here as I assume there will be stall)
    ---------------------------------------------------------------------------------------------------------------------
    MEM_OPCODE_WR_OP <= '0' 
    when EX_MEM_OPCODE = "00100" OR  EX_MEM_OPCODE = "00000" OR EX_MEM_OPCODE = "10000" OR  EX_MEM_OPCODE = "10100" 
     OR  EX_MEM_OPCODE = "11000" OR  EX_MEM_OPCODE = "11001" OR EX_MEM_OPCODE = "11010" 
     OR  EX_MEM_OPCODE = "11011" OR  EX_MEM_OPCODE = "11100" 
    else '1';
    --------------------------------------------------------------------------------------------------------------------	

    --Checking WB OPCODE FOR WRITE OPERATIONS
    ---------------------------------------------------------------------------------------------------------------------
    WB_OPCODE_WR_MEM_OP <= "00" 
    when MEM_WB_OPCODE = "00100" OR  MEM_WB_OPCODE = "00000" OR MEM_WB_OPCODE = "10000" OR  MEM_WB_OPCODE = "10100" 
     OR  MEM_WB_OPCODE = "11000" OR  MEM_WB_OPCODE = "11001" OR MEM_WB_OPCODE = "11010" 
     OR  MEM_WB_OPCODE = "11011" OR  MEM_WB_OPCODE = "11100" 
    else "10" when MEM_WB_OPCODE = "10001" OR MEM_WB_OPCODE = "10011" OR MEM_WB_OPCODE = "10011"
    else "01";
    --------------------------------------------------------------------------------------------------------------------	

    --Checking for Hazard in src 1 Read After Write 
    --------------------------------------------------------------
    Src1_Read_After_Write_Hazard_MEM <= '1'
    when ALU_OPCODE_READ_OP = '1' AND MEM_OPCODE_WR_OP ='1' AND ALU_Rsrc1_Address = EX_MEM_Rdst_Address
    else '0';

    Src1_Read_After_Write_Hazard_WB <= '1'
    when ALU_OPCODE_READ_OP = '1' AND WB_OPCODE_WR_MEM_OP ="01" AND ALU_Rsrc1_Address = MEM_WB_Rdst_Address
    else '0';
    ---------------------------------------------------------------

    
    --Checking for Hazard in src 2 Read After Write 
    --------------------------------------------------------------
    Src2_Read_After_Write_Hazard_MEM <= '1'
    when ALU_OPCODE_READ_OP = '1' AND MEM_OPCODE_WR_OP ='1' AND ALU_Rsrc2_Address = EX_MEM_Rdst_Address
    else '0';

    
    Src2_Read_After_Write_Hazard_WB <= '1'
    when ALU_OPCODE_READ_OP = '1' AND WB_OPCODE_WR_MEM_OP ="01" AND ALU_Rsrc2_Address = MEM_WB_Rdst_Address
    else '0';
    ---------------------------------------------------------------

    
    --Checking for Hazard in src 1 Read After MEM 
    --------------------------------------------------------------
    Src1_Read_After_Mem_Hazard_WB <= '1'
    when ALU_OPCODE_READ_OP = '1' AND WB_OPCODE_WR_MEM_OP ="10" AND ALU_Rsrc1_Address = MEM_WB_Rdst_Address
    else '0';
    ---------------------------------------------------------------

    
    --Checking for Hazard in src 2 Read After MEM 
    --------------------------------------------------------------
    Src2_Read_After_Mem_Hazard_WB <= '1'
    when ALU_OPCODE_READ_OP = '1' AND WB_OPCODE_WR_MEM_OP ="10" AND ALU_Rsrc2_Address = MEM_WB_Rdst_Address
    else '0';
    ---------------------------------------------------------------

    --handling Src 1
    --------------------------------------------------------
    Rsrc1_Selector <= "00"
    when Src1_Read_After_Write_Hazard_MEM = '0' AND Src1_Read_After_Write_Hazard_WB = '0' AND Src1_Read_After_Mem_Hazard_WB = '0'
    else "01" when  Src1_Read_After_Write_Hazard_MEM = '1'
    else "10" when Src1_Read_After_Write_Hazard_WB = '1' OR Src1_Read_After_Mem_Hazard_WB = '1' ;
    --------------------------------------------------------

    --handling src 2
    ----------------------------------------------------------
    Rsrc2_Selector <= "00"
    when Src2_Read_After_Write_Hazard_MEM = '0' AND Src2_Read_After_Write_Hazard_WB = '0' AND Src2_Read_After_Mem_Hazard_WB = '0'
    else "01" when  Src2_Read_After_Write_Hazard_MEM = '1'
    else "10" when Src2_Read_After_Write_Hazard_WB = '1' OR Src2_Read_After_Mem_Hazard_WB = '1' ;
    ----------------------------------------------------------
    
  
    
    end architecture;