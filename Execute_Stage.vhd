
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity Execute_Stage_Entity is 
port(
--ID/EX INPUTS
PC_Rdst_Data_In,Control_Signals_In,Read_Data1_In
,Read_Data2_In,Extend_Mux_Output: in std_logic_vector (31 downto 0) ;
DST_SRC_Addresses_In: in std_logic_vector (5 downto 0) ; 

--EX/MEM Outputs
PC_Rdst_Data_Out,Control_Signals_Out,ALU_Result_Out,Read_Data2_Out: out std_logic_vector (31 downto 0) ;
DST_SRC_Addresses_Out: out std_logic_vector (5 downto 0) ; 

--Forwarding data
Mem_Forwarding , WB_Forwarding: in std_logic_vector (31 downto 0) ;

--Forwarding unit selectors
Forwarding_Selectors1,Forwarding_Selectors2 : in std_logic_vector (1 downto 0) ;

--In Port Data
In_Port: in std_logic_vector (31 downto 0) ;

--flags
flags : inout std_logic_vector (3 downto 0) ; 

--clk , enable , reset
clk,Enable,Reset: in std_logic);

end entity Execute_Stage_Entity;

architecture Execute_Stage_Arch of Execute_Stage_Entity is 
--------------------------------------------------------------------------------
-------------------------------components---------------------------------------
--------------------------------------------------------------------------------

--ALU Component
-----------------------------------------------------------
component ALU_ENTITY is 
port(
Data1,Data2: in std_logic_vector (31 downto 0); 
OpCode: in std_logic_vector(3 downto 0);
enable : in std_logic;
Flags:inout std_logic_vector(3 downto 0) := (OTHERS => '0');
Result : out std_logic_vector(31 downto 0));
end component ALU_ENTITY;
-----------------------------------------------------------

--Src 1 Mux Component
-----------------------------------------------------------
component ALU_SRC1_MUX_Entity is 
port(
Rsrc_Data1,ALU_Buffer_Data,Memory_Buffer_Data: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(1 downto 0);
F : out std_logic_vector(31 downto 0));
end component ALU_SRC1_MUX_Entity;
-----------------------------------------------------------

--Src 2 Mux Component
-----------------------------------------------------------
component ALU_SRC2_MUX_Entity is 
port(
Rsrc_Data2,Immediate_Value,ALU_Buffer_Data,Memory_Buffer_Data,IN_PORT: in std_logic_vector (31 downto 0) ; 
ALU_SRC,IN_P: in std_logic;
Forwarding_Unit_Sel: in std_logic_vector (1 downto 0);
F : out std_logic_vector(31 downto 0));
end component ALU_SRC2_MUX_Entity;
-----------------------------------------------------------

--signals
signal Src1_Mux_Output,Src2_Mux_Output : std_logic_vector(31 downto 0);

begin
--------------------------------------------------------------------------------
-------------------------------beginning Architecture---------------------------
--------------------------------------------------------------------------------
--EX/MEM Outputs
PC_Rdst_Data_Out  <= PC_Rdst_Data_In;
Control_Signals_Out <= Control_Signals_In;
Read_Data2_Out <= Read_Data2_In;
DST_SRC_Addresses_Out <= DST_SRC_Addresses_In;


Mux1      : ALU_SRC1_MUX_Entity port map (Read_Data1_In ,WB_Forwarding,Mem_Forwarding ,
                                          Forwarding_Selectors1 ,Src1_Mux_Output  );

Mux2      : ALU_SRC2_MUX_Entity port map (Read_Data2_In , Extend_Mux_Output ,WB_Forwarding,
                                          Mem_Forwarding , In_Port ,
                                          Control_Signals_In(25) , Control_Signals_In(30) , Forwarding_Selectors2,Src2_Mux_Output  );

ALU_Label : ALU_ENTITY          port map (Src1_Mux_Output , Src2_Mux_Output 
                                          ,Control_Signals_In(29 downto 26), enable , flags ,ALU_Result_Out);


end architecture Execute_Stage_Arch;