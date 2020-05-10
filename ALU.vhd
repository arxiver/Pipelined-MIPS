
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_STD.ALL;

entity ALU_ENTITY is 
port(

Data1,Data2: in std_logic_vector (31 downto 0); 
OpCode: in std_logic_vector(3 downto 0);
enable : in std_logic;
Flags:inout std_logic_vector(3 downto 0) := (OTHERS => '0');
Result : out std_logic_vector(31 downto 0));


end entity ALU_ENTITY;


architecture ALU_ARCH of ALU_ENTITY is


    --PORT A COMPONENT
 component ALU_PortA_Entity is 
port(
Data1,Data2: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(2 downto 0);
Flags:inout std_logic_vector(3 downto 0) := (OTHERS => '0');
F : out std_logic_vector(31 downto 0));

end component ALU_PortA_Entity;

    
    --PORT B COMPONENT
 component ALU_PORTB_ENTITY is 
port(
Data1,Data2: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(2 downto 0);
Flags : inout std_logic_vector (3 downto 0) := (OTHERS => '0'); 
F : out std_logic_vector(31 downto 0));
end component ALU_PORTB_ENTITY;

    
   
    
    signal PAOUT,PBOUT  :std_logic_vector (31 downto 0);
    signal  FA, FB, FC  :std_logic_vector (3 downto 0) := (Flags);
    
    Begin
    pa:ALU_PORTA_ENTITY PORT MAP(Data1,Data2,OpCode(2 downto 0),FA,PAOUT) ;
    pb:ALU_PORTB_ENTITY PORT MAP(Data1,Data2,OpCode(2 downto 0),FB,PBOUT) ;
    
    Flags <= FA  WHEN OpCode(3) ='0' and enable = '1'
    ELSE FB when OpCode(3) ='1' and enable = '1' ;
    
    Result <= PAOUT  WHEN OpCode(3) ='0' 
    ELSE PBOUT ;
    
    
  
    
    end architecture;