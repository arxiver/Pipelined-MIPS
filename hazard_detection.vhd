Library IEEE;
USE IEEE.std_logic_1164.all;

entity Hazard_Detection_Unit_Entity is
    port(
        --inputs
        IF_ID_OPCODE,
        ID_EX_OPCODE,
        EX_MEM_OPCODE : in std_logic_vector(4 downto 0);    

        IF_ID_Rsrc1,
        IF_ID_Rsrc2,
        IF_ID_Rdst : in std_logic_vector(2 downto 0);

        ID_EX_Rsrc1,
        ID_EX_Rsrc2,
        ID_EX_Rdst : in std_logic_vector(2 downto 0);

        EX_MEM_Rsrc1,
        EX_MEM_Rsrc2,
        EX_MEM_Rdst : in std_logic_vector(2 downto 0);
    	
	clk : in std_logic;

        --outputs
        Stall:out std_logic :='0';
        IF_ID_Write_Enable :out std_logic :='1'
    );
end entity;

architecture Hazard_Detection_Unit_Arch of Hazard_Detection_Unit_Entity is   

Signal IF_ID_Read_OP : std_logic;

Signal   ID_EX_OP,
         EX_MEM_OP : std_logic_vector(1 downto 0);

Signal  Stall_First_Case,
        Stall_Second_Case,
        Stall_Third_Case,
        Stall_Fourth_Case,
        Stall_Fifth_Case,
        Stall_Sixth_Case:std_logic;
begin

 --checking write operations in ID_EX
    ----------------------------------------------------
    ID_EX_OP <= "00" 
    when ID_EX_OPCODE = "00100" OR  ID_EX_OPCODE = "00000" OR ID_EX_OPCODE = "10000" OR  ID_EX_OPCODE = "10100" 
     OR  ID_EX_OPCODE = "11000" OR  ID_EX_OPCODE = "11001" OR ID_EX_OPCODE = "11010" 
     OR  ID_EX_OPCODE = "11011" OR  ID_EX_OPCODE = "11100" OR ID_EX_OPCODE = "01000" --not wr or mem operation
    else "10" when ID_EX_OPCODE = "10001" OR ID_EX_OPCODE = "10011" OR ID_EX_OPCODE = "10011" --mem op
    else "01"; --wr op
    ----------------------------------------------------

    --checking write operations in EX_MEM
    ----------------------------------------------------
    EX_MEM_OP <= "00"
    when EX_MEM_OPCODE = "00100" OR  EX_MEM_OPCODE = "00000" OR EX_MEM_OPCODE = "10000" OR  EX_MEM_OPCODE = "10100" 
     OR  EX_MEM_OPCODE = "11000" OR  EX_MEM_OPCODE = "11001" OR EX_MEM_OPCODE = "11010" 
     OR  EX_MEM_OPCODE = "11011" OR  EX_MEM_OPCODE = "11100" OR  EX_MEM_OPCODE = "01000"  --not wr or mem operation
     else "10" when EX_MEM_OPCODE = "10001" OR EX_MEM_OPCODE = "10011" OR EX_MEM_OPCODE = "10011" --mem op
     else "01"; --wr op
    -----------------------------------------------------

    --Checking IF_ID FOR READ OPERATIONS
    ---------------------------------------------------------------------------------------------------------------------
    IF_ID_Read_OP <= '0' 
    when IF_ID_OPCODE = "00101" OR IF_ID_OPCODE = "00000" OR IF_ID_OPCODE = "10001" OR  IF_ID_OPCODE = "10010" 
     OR  IF_ID_OPCODE = "10011" OR  IF_ID_OPCODE = "11000" OR IF_ID_OPCODE = "11001" OR IF_ID_OPCODE = "01000"
     OR  IF_ID_OPCODE = "11011" OR  IF_ID_OPCODE = "11100" OR IF_ID_OPCODE ="10100" OR IF_ID_OPCODE ="10000"
    else '1';
    --------------------------------------------------------------------------------------------------------------------	

    --First case (special case of push and std): 
    --when IF_ID is push or STD and ID_EX or EX_MEM is write and Rdst = Rsrc we should stall
    Stall_First_Case <= '1' 
    when (IF_ID_OPCODE = "10000" OR IF_ID_OPCODE = "10100") 
    and ((ID_EX_OP /= "00"  and (IF_ID_Rsrc2 = ID_EX_Rdst))
    OR (EX_MEM_OP /= "00"  and IF_ID_Rsrc2 = EX_MEM_Rdst))
    else '0';

    --Second case (special case of push and std): 
    --when IF_ID is push or STD and ID_EX or EX_MEM is SWAP and Rdst(swap) = Rsrc , Rsrc(swap) = Rsrc we should stall
    Stall_Second_Case <= '1' 
    when (IF_ID_OPCODE = "10000" OR IF_ID_OPCODE = "10100") 
    and ((ID_EX_OPCODE = "01000"  and (IF_ID_Rsrc2 = ID_EX_Rdst OR IF_ID_Rsrc2 = ID_EX_Rsrc1))
    OR (EX_MEM_OPCODE = "01000"  and (IF_ID_Rsrc2 = EX_MEM_Rdst OR IF_ID_Rsrc2 = EX_MEM_Rsrc1)))
    else '0';

    --Third  case (special case of  swap): 
    --when IF_ID is swap and ID_EX or EX_MEM is write , Rsrc2(swap) = Rdst(write) or Rdst(swap) = Rdst(write)  we should stall
    Stall_Third_Case <= '1' 
    when IF_ID_OPCODE = "01000"
    and ((ID_EX_OP = "01"  and (IF_ID_Rsrc1 = ID_EX_Rdst OR IF_ID_Rdst = ID_EX_Rdst))
    OR (EX_MEM_OP = "01"  and (IF_ID_Rsrc1 = EX_MEM_Rdst OR IF_ID_Rdst = EX_MEM_Rdst)))
    else '0';

    --Fourth  case (special case of  swap): 
    --when IF_ID is read and ID_EX or EX_MEM is swap , Rsrc1(read) = Rdst(swap) or Rsrc2(read) = Rdst(swap)
    --or Rsrc1(read) = Rsrc2(swap) or Rsrc2(read) = Rsrc2(swap)  we should stall
    Stall_Fourth_Case <= '1'
    when IF_ID_Read_OP = '1'
    and ((ID_EX_OPCODE = "01000"  and (IF_ID_Rsrc1 = ID_EX_Rdst OR IF_ID_Rsrc2 = ID_EX_Rdst OR IF_ID_Rsrc1 = ID_EX_Rsrc1 OR IF_ID_Rsrc2 = ID_EX_Rsrc1))
    OR  (EX_MEM_OPCODE =  "01000"  and  (IF_ID_Rsrc1 = EX_MEM_Rdst OR IF_ID_Rsrc2 = EX_MEM_Rdst OR IF_ID_Rsrc1 = EX_MEM_Rsrc1 OR IF_ID_Rsrc2 = EX_MEM_Rsrc1)))
    else '0';

    --Fifth  case (special case of  swap): 
    --when IF_ID is swap and ID_EX or EX_MEM is swap , Rsrc2(read) = Rdst(swap) or Rdst(read) = Rdst(swap)
    --or Rsrc2(read) = Rdst(swap) or Rdst(read) = Rsrc2(swap)  we should stall
    Stall_Fifth_Case <= '1' 
    when IF_ID_OPCODE = "01000"
    and ((ID_EX_OPCODE = "01000"  and (IF_ID_Rsrc1 = ID_EX_Rdst OR IF_ID_Rdst = ID_EX_Rdst OR IF_ID_Rsrc1 = ID_EX_Rsrc1 OR IF_ID_Rdst = ID_EX_Rsrc1))
    OR (EX_MEM_OPCODE =  "01000"  and  (IF_ID_Rsrc1 = EX_MEM_Rdst OR IF_ID_Rdst = EX_MEM_Rdst OR IF_ID_Rsrc1 = EX_MEM_Rsrc1 OR IF_ID_Rdst = EX_MEM_Rsrc1)))
    else '0';

    --Sixth  case : 
    --when IF_ID is read and ID_EX is LOAD and Rsrc1 or Rsrc2 = Rdst  we should stall
    Stall_Sixth_Case <= '1'
    when IF_ID_Read_OP = '1'
    and (ID_EX_OP = "10"  and (IF_ID_Rsrc1 = ID_EX_Rdst OR IF_ID_Rsrc2 = ID_EX_Rdst))
    else '0';

--Stall <= '1' 
-- when  Stall_First_Case = '1' OR Stall_Second_Case = '1' OR Stall_Third_Case = '1' 
--      OR Stall_Fourth_Case = '1' OR Stall_Fifth_Case = '1' OR Stall_Sixth_Case = '1'
--else '0' ;
-- 
--IF_ID_Write_Enable <= '0'
--when Stall_First_Case = '1' OR Stall_Second_Case = '1' OR Stall_Third_Case = '1' 
--      OR Stall_Fourth_Case = '1' OR Stall_Fifth_Case = '1' OR Stall_Sixth_Case = '1'
--
--else '1' ;


process (clk)
    begin	
   

    if((rising_edge(clk))) then
    
    
    if( Stall_First_Case = '1' OR Stall_Second_Case = '1' OR Stall_Third_Case = '1' 
      OR Stall_Fourth_Case = '1' OR Stall_Fifth_Case = '1' OR Stall_Sixth_Case = '1')
    then   Stall <= '1' ;
    else Stall <= '0' ;
    end if;	
    
    if( Stall_First_Case = '1' OR Stall_Second_Case = '1' OR Stall_Third_Case = '1' 
      OR Stall_Fourth_Case = '1' OR Stall_Fifth_Case = '1' OR Stall_Sixth_Case = '1')
    then   IF_ID_Write_Enable <= '0' ;
    else IF_ID_Write_Enable <= '1' ;
    end if;

    end if;
end process;
    end architecture;
    