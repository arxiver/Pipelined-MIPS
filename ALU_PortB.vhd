
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity ALU_PORTB_ENTITY is 
port(
Data1,Data2: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(2 downto 0);
Flags : inout std_logic_vector (3 downto 0) := (OTHERS => '0'); 
F : out std_logic_vector(31 downto 0));
end entity ALU_PORTB_ENTITY;

architecture ALU_PORTB_ARCH of ALU_PORTB_ENTITY is 
signal Fbuffer : std_logic_vector(31 downto 0);
begin


    Fbuffer <= Data1  When S = "000"  -- F = Data1
    else Data2        when  S =  "001"   --F = Data2
    else (Data1(30 downto 0) & '0')        when  S =  "010"   --shift left
    else ('0' & Data1(31 downto 1));  --F = !Y
    
    F <= Fbuffer;

    --don`t forget to update flags

end architecture ALU_PORTB_ARCH;