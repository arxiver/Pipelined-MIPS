
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity ALU_PortA_Entity is 
port(
Data1,Data2: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(2 downto 0);
FlagsIn:in std_logic_vector(2 downto 0);
FlagsOut:out std_logic_vector(2 downto 0) ;
F : out std_logic_vector(31 downto 0));

end entity ALU_PortA_Entity;

architecture ALU_PortA_Arch of ALU_PortA_Entity is 

component my_nadder IS
PORT   (     a, b : IN std_logic_vector(31 DOWNTO 0) ;
             cin : IN std_logic;
             s : OUT std_logic_vector(31 DOWNTO 0);
             cout : OUT std_logic);
end component my_nadder;

signal AND_OP,OR_OP,ADD_OP,SUB_OP,INC_OP,DEC_OP,DECYop,DATA1_BAR,DATA2_BAR,F_Buffer : std_logic_vector(31 downto 0);
signal Cout_ADD,Cout_SUB,Cout_INC,Cout_DEC , Temp1,Temp2 : std_logic ;
signal CINbar: std_logic ;
begin
----------------------------------------------------------------------------------
--Invert
DATA1_BAR <= not Data1;
DATA2_BAR <= not Data2;
--AND
AND_OP <= Data1 and Data2;
--OR
OR_OP <= Data1 or Data2;
-- ADDop = Data1 + Data2
ADDsig : my_nadder port map(Data1,Data2,'0',ADD_op,Cout_ADD);
-- SUB = Data1 - Data2
SUBsig: my_nadder port map(Data1,DATA2_BAR,'1',SUB_op,Temp1);
-- INCop = Data1 + 1
INCBUSsig : my_nadder port map(Data1,(others=>'0'),'1',INC_op,Cout_INC);
-- DECBUSop = Data1 - 1
DECBUSsig: my_nadder port map(Data1,(others=>'1'),'0',DEC_op,Temp2);
-------------------------------------------------------------------------------------

F_Buffer <= (DATA1_BAR)   When S = "000"  -- NOT	
    else (INC_OP)    when  S =  "001"     --INC
    else (DEC_OP) when  S =  "010"         -- DEC
    else (ADD_OP)   when  S =  "011"      --ADD
    else (SUB_OP) when  S =  "100"      --SUB
    else (AND_OP)   when  S =  "101"      --AND
    else (OR_OP)  when  S =  "110"     --OR
    else (INC_OP)  when  S =  "111" ;     --JZ 
	
    F <= F_Buffer;

Cout_SUB <= '1' when S = "100" and Data2 > Data1
	else '0';

Cout_DEC <= '1' when S = "010" and Data1 = "00000000000000000000000000000000"
	else '0';

   --carry flag
    FlagsOut(2) <= Cout_INC when  S="001"  --INC
    else Cout_DEC when S = "010"  --DEC 
    else Cout_ADD when S = "011"    --ADD
    else Cout_SUB when S = "100"  --SUB
    else FlagsIn(2) ;
      

   
    --Negative flag
    FlagsOut(1) <= F_Buffer(31) when S /= "111" 
    else FlagsIn(1);

    --zero flag
    FlagsOut(0) <= '1' When  F_Buffer="00000000000000000000000000000000" and S /= "111"
    else '0' ; --jz
	
  

end architecture ALU_PortA_Arch;