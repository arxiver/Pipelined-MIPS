
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_STD.ALL;

entity ALU_PORTB_ENTITY is 
port(
Data1,Data2: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(2 downto 0);
Flags : inout std_logic_vector (3 downto 0) := (OTHERS => '0'); 
F : out std_logic_vector(31 downto 0));
end entity ALU_PORTB_ENTITY;

architecture ALU_PORTB_ARCH of ALU_PORTB_ENTITY is 
signal Fbuffer,ShiftL,ShiftR : std_logic_vector(31 downto 0);
begin
    
    ShiftL<=  std_logic_vector(shift_left (unsigned(Data1),  to_integer(unsigned(Data2))));
    ShiftR<=  std_logic_vector(shift_right(unsigned(Data1),  to_integer(unsigned(Data2))));

    Fbuffer <= Data1  When S = "000"  -- F = Data1
    else Data2        when  S =  "001"   --F = Data2
    else ShiftL        when  S =  "010"   --shift left
    else ShiftR        when  S =  "011"   --shift right
    else Data1;  
    
    F <= Fbuffer;

    
    Flags(2) <= Data1(1) when  S="010"  --INC
    else Data1(1) when S = "011" --DEC 
    else Flags(2) ;
      

   
    --Negative flag
    Flags(1) <= Fbuffer(31) when S = "010"  or S = "011"
    else Flags(1);

    --zero flag
    Flags(0) <= '1' When  Fbuffer="00000000000000000000000000000000" and (S = "010" or S = "011")
    else '0' when Fbuffer /="00000000000000000000000000000000" and (S = "010" or S = "011")
    else Flags(0)  ; 
	

    --don`t forget to update flags

end architecture ALU_PORTB_ARCH;