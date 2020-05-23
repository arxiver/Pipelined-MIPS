


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity ALU_SRC2_MUX_Entity is 
port(
Rsrc_Data2,Immediate_Value,ALU_Buffer_Data,Memory_Buffer_Data,IN_PORT: in std_logic_vector (31 downto 0) ; 
ALU_SRC,IN_P: in std_logic;
Forwarding_Unit_Sel: in std_logic_vector (1 downto 0);
F : out std_logic_vector(31 downto 0));
end entity ALU_SRC2_MUX_Entity;

architecture ALU_SRC2_MUX_ARCH of ALU_SRC2_MUX_Entity is 
begin
F <=  ALU_Buffer_Data  WHEN Forwarding_Unit_Sel(1) = '0' and Forwarding_Unit_Sel(0) = '1'
ELSE Memory_Buffer_Data  WHEN Forwarding_Unit_Sel(1) = '1' and Forwarding_Unit_Sel(0) = '0'
ELSE IN_PORT  WHEN IN_P = '1'
ELSE Immediate_Value  WHEN ALU_SRC = '1'
ELSE Rsrc_Data2;


  

end architecture ALU_SRC2_MUX_ARCH;