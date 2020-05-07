


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity ALU_SRC2_MUX_Entity is 
port(
Rsrc_Data2,Immediate_Value,ALU_Buffer_Data,Memory_Buffer_Data,IN_PORT: in std_logic_vector (31 downto 0) ; 
ALU_SRC,IN_P,Forwarding_Unit_Output: in std_logic;
F : out std_logic_vector(31 downto 0));
end entity ALU_SRC2_MUX_Entity;

architecture ALU_SRC2_MUX_ARCH of ALU_SRC2_MUX_Entity is 
begin

    F <= Rsrc_Data2 when ALU_SRC = '1' 
ELSE IN_PORT  WHEN IN_P = '1'
--ELSE Immediate_Value  WHEN 
--ELSE ALU_Buffer_Data  WHEN 
--ELSE Memory_Buffer_Data  WHEN 
ELSE Rsrc_Data2;

end architecture ALU_SRC2_MUX_ARCH;