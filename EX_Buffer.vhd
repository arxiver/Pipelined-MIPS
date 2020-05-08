
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity EX_Buffer_Entity is 
port(
EXMEM_ALU_RESULT_IN:in  std_logic_vector (31 downto 0);
EXMEM_CONTROL_SIGNALS_IN :in std_logic_vector (26 downto 0);
EXMEM_PC_IN :in  std_logic_vector (31 downto 0);
EXMEM_Rdst_IN :in  std_logic_vector (31 downto 0);
EXMEM_Rsrc2_IN :in  std_logic_vector (31 downto 0);
EXMEM_Rdst_address_IN :in  std_logic_vector (2 downto 0);
EXMEM_Rsrc1_address_IN :in  std_logic_vector (2 downto 0);
EXMEM_Rsrc2_address_IN :in  std_logic_vector (2 downto 0); 

EXMEM_ALU_RESULT_OUT:out  std_logic_vector (31 downto 0);
EXMEM_CONTROL_SIGNALS_OUT :out std_logic_vector (26 downto 0);
EXMEM_PC_OUT :out  std_logic_vector (31 downto 0);
EXMEM_Rdst_OUT :out  std_logic_vector (31 downto 0);
EXMEM_Rsrc2_OUT :out  std_logic_vector (31 downto 0);
EXMEM_Rdst_address_OUT :out  std_logic_vector (2 downto 0);
EXMEM_Rsrc1_address_OUT :out  std_logic_vector (2 downto 0);
EXMEM_Rsrc2_address_OUT :out  std_logic_vector (2 downto 0); 

Wr,clk,reset : in std_logic);
end entity EX_Buffer_Entity;

architecture EX_Buffer_Arch of EX_Buffer_Entity is
-- Register COMPONENT
COMPONENT reg is 
generic (n:integer := 32);
port(	clk : in std_logic ; 
	reset : in std_logic ; 
	enable : in std_logic ; 
	d	: in std_logic_vector(n-1 downto 0);
	q	: out std_logic_vector(n-1 downto 0)
);
END COMPONENT;

begin 
EXMEM_ALU_RESULT_Label  		: reg generic map (n   => 32) port map (clk , reset , Wr ,EXMEM_ALU_RESULT_IN , EXMEM_ALU_RESULT_OUT );
EXMEM_CONTROL_SIGNALS_Label  	: reg generic map (n   => 27) port map (clk , reset , Wr ,EXMEM_CONTROL_SIGNALS_IN , EXMEM_CONTROL_SIGNALS_OUT );
EXMEM_PC_Label  				: reg generic map (n   => 32) port map (clk , reset , Wr ,EXMEM_PC_IN , EXMEM_PC_OUT );
EXMEM_Rdst_Label  				: reg generic map (n   => 32) port map (clk , reset , Wr ,EXMEM_Rdst_IN , EXMEM_Rdst_OUT );
EXMEM_Rsrc2_Label  		    	: reg generic map (n   => 32) port map (clk , reset , Wr ,EXMEM_Rsrc2_IN, EXMEM_Rsrc2_OUT );
EXMEM_Rdst_address_Label  		: reg generic map (n   => 3)  port map (clk , reset , Wr ,EXMEM_Rdst_address_IN ,EXMEM_Rdst_address_OUT );
EXMEM_Rsrc1_address_Label   	: reg generic map (n   => 3)  port map (clk , reset , Wr ,EXMEM_Rsrc1_address_IN , EXMEM_Rsrc1_address_OUT );
EXMEM_Rsrc2_address_Label   	: reg generic map (n   => 3)  port map (clk , reset , Wr ,EXMEM_Rsrc2_address_IN , EXMEM_Rsrc2_address_OUT );

end architecture EX_Buffer_Arch;