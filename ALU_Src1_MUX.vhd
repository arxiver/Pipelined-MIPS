

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity ALU_SRC1_MUX_Entity is 
port(
Rsrc_Data1,ALU_Buffer_Data,Memory_Buffer_Data: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(1 downto 0);
F : out std_logic_vector(31 downto 0));
end entity ALU_SRC1_MUX_Entity;

architecture ALU_SRC1_MUX_ARCH of ALU_SRC1_MUX_Entity is 
begin

    F <= Rsrc_Data1 when S(1) = '0' and S(0) = '0'
ELSE ALU_Buffer_Data  WHEN S(1) = '0' and S(0) = '1'
ELSE Memory_Buffer_Data  WHEN S(1) = '1' and S(0) = '0'
ELSE Rsrc_Data1;

end architecture ALU_SRC1_MUX_ARCH;