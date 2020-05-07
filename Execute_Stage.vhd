



LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity Execute_Stage_Entity is 
port(
: in std_logic_vector (31 downto 0) ; 
: in std_logic_vector (5 downto 0) ; 
: in std_logic;
: out std_logic_vector(31 downto 0));
end entity Execute_Stage_Entity;

architecture Execute_Stage_Arch of Execute_Stage_Entity is 
begin

    F <= Rsrc_Data2 when ALU_SRC = '1' 
ELSE IN_PORT  WHEN IN_P = '1'
--ELSE Immediate_Value  WHEN 
--ELSE ALU_Buffer_Data  WHEN 
--ELSE Memory_Buffer_Data  WHEN 
ELSE Rsrc_Data2;

end architecture Execute_Stage_Arch;