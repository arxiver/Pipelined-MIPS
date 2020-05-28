
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_STD.ALL;

entity ALU_ENTITY is 
port(

Data1,Data2: in std_logic_vector (31 downto 0); 
OpCode: in std_logic_vector(3 downto 0);
enable : in std_logic;
FlagsIn:in std_logic_vector(2 downto 0)  ;
FlagsOut:out std_logic_vector(2 downto 0) ;
Result : out std_logic_vector(31 downto 0));


end entity ALU_ENTITY;


architecture ALU_ARCH of ALU_ENTITY is


 
component ALU_PortA_Entity is 
port(
Data1,Data2: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(2 downto 0);
FlagsIn:in std_logic_vector(2 downto 0);
FlagsOut:out std_logic_vector(2 downto 0) ;
F : out std_logic_vector(31 downto 0));

end component ALU_PortA_Entity;


  
component ALU_PORTB_ENTITY is 
port(
Data1,Data2: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(2 downto 0);
FlagsIn : in std_logic_vector (2 downto 0) ; 
FlagsOut : out std_logic_vector (2 downto 0) ; 
F : out std_logic_vector(31 downto 0));
end component ALU_PORTB_ENTITY;

    
   
    
    signal PAOUT,PBOUT  :std_logic_vector (31 downto 0);
    signal  FA, FB, FC  :std_logic_vector (2 downto 0);
    
    Begin
    pa:ALU_PORTA_ENTITY PORT MAP(Data1,Data2,OpCode(2 downto 0),FlagsIn,FA,PAOUT) ;
    pb:ALU_PORTB_ENTITY PORT MAP(Data1,Data2,OpCode(2 downto 0),FlagsIn,FB,PBOUT) ;
    
    FlagsOut <= FA  WHEN OpCode(3) ='0' and enable = '1'
    ELSE FB when OpCode(3) ='1' and enable = '1' ;
    
    Result <= PAOUT  WHEN OpCode(3) ='0' 
    ELSE PBOUT ;
    
    
  
    
    end architecture;