
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity Execute_Stage_Entity is 
port(
--ID/EX INPUTS
IDEX_CONTROL_SIGNALS :in std_logic_vector (26 downto 0);
IDEX_PC :in  std_logic_vector (31 downto 0);
IDEX_Rdst :in  std_logic_vector (31 downto 0);
IDEX_Rsrc1 :in  std_logic_vector (31 downto 0);
IDEX_Rsrc2 :in  std_logic_vector (31 downto 0);
IDEX_EA_IMM_DATA :in  std_logic_vector (31 downto 0);
IDEX_Rdst_address :in  std_logic_vector (2 downto 0);
IDEX_Rsrc1_address :in  std_logic_vector (2 downto 0);
IDEX_Rsrc2_address :in  std_logic_vector (2 downto 0); 
ID_EX_OPCODE : in std_logic_vector (4 downto 0); 

--EX/MEM Outputs
EXMEM_ALU_RESULT:out  std_logic_vector (31 downto 0);
EXMEM_CONTROL_SIGNALS :out std_logic_vector (26 downto 0);
EXMEM_PC :out  std_logic_vector (31 downto 0);
EXMEM_Rdst :out  std_logic_vector (31 downto 0);
EXMEM_Rsrc2 :out  std_logic_vector (31 downto 0);
EXMEM_Rdst_address :out  std_logic_vector (2 downto 0);
EXMEM_Rsrc1_address :out  std_logic_vector (2 downto 0);
EXMEM_Rsrc2_address :out  std_logic_vector (2 downto 0); 
EX_MEM_OPCODE : out std_logic_vector (4 downto 0); 

--Forwarding data
Mem_Forwarding , WB_Forwarding: in std_logic_vector (31 downto 0) ;

--Forwarding unit selectors
Forwarding_Selectors1,
Forwarding_Selectors2 : in std_logic_vector (1 downto 0) ;

--In Port Data
In_Port: in std_logic_vector (31 downto 0) ;

--flags
flags : inout std_logic_vector (2 downto 0)  ; 

--clk , enable , reset
clk,
Enable,
Reset: in std_logic);

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
Flags:inout std_logic_vector(2 downto 0) ;
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
EXMEM_PC  <= IDEX_PC;  --Forwarding PC value to next buffer
EXMEM_Rdst <= IDEX_Rdst; --Forwarding R dst value to next buffer
EXMEM_Rsrc2 <= IDEX_Rsrc2; --Forwarding Rsrc2 value to next buffer
EXMEM_Rdst_address  <= IDEX_Rdst_address; --Forwarding Rdst address to next buffer
EXMEM_Rsrc1_address <= IDEX_Rsrc1_address; --Forwarding Rsrc1 address to next buffer
EXMEM_Rsrc2_address <= IDEX_Rsrc2_address; --Forwarding Rsrc2 address to next buffer
EXMEM_CONTROL_SIGNALS <= IDEX_CONTROL_SIGNALS; --Forwarding Control signals to next buffer
EX_MEM_OPCODE <= ID_EX_OPCODE;--Forwarding OpCode to next buffer

--Mux selecting input #1 to the ALU
Mux1      : ALU_SRC1_MUX_Entity port map (IDEX_Rsrc1 ,    --R source 1
                                          Mem_Forwarding , --Data forwarded from memory
                                          WB_Forwarding,  --Data farwarded from WB
                                          Forwarding_Selectors1 , --Selectors sent from Forwarding unit
                                          Src1_Mux_Output  );  --Output

--Mux selecting input #2 to the ALU
Mux2      : ALU_SRC2_MUX_Entity port map (IDEX_Rsrc2 ,  --R source 1
                                          IDEX_EA_IMM_DATA , --Immediate or Effective address data
                                          Mem_Forwarding , --Data forwarded from memory
                                          WB_Forwarding,  --Data farwarded from WB
                                          In_Port , --In port data
                                          IDEX_CONTROL_SIGNALS(6) ,  --ALU SRC selector
                                          IDEX_CONTROL_SIGNALS(1) , --In port selector
                                          Forwarding_Selectors2, --Selectors sent from Forwarding unit
                                          Src2_Mux_Output  ); --output


ALU_Label : ALU_ENTITY          port map (Src1_Mux_Output , --MUX1 OUTPUT
                                          Src2_Mux_Output , --MUX2 OUTPUT
                                          IDEX_CONTROL_SIGNALS(5 downto 2), --ALU OP CODE 
                                          IDEX_CONTROL_SIGNALS(11) , --ENABLE
                                          flags , --FLAGS
                                          EXMEM_ALU_RESULT); --OUTPUT


end architecture Execute_Stage_Arch;