
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity EX_Buffer_Entity is 
port(
PC_Rdst_Data_In,Control_Signals_In,ALU_Result_In,Read_Data2_In: in std_logic_vector (31 downto 0) ;
DST_SRC_Addresses_In: in std_logic_vector (5 downto 0) ; 
PC_Rdst_Data_Out,Control_Signals_Out,ALU_Result_Out,Read_Data2_Out: out std_logic_vector (31 downto 0) ;
DST_SRC_Addresses_Out: out std_logic_vector (5 downto 0) ; 
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
PC_Rdst_Data      : reg generic map (n   => 32) port map(clk, reset, Wr, PC_Rdst_Data_In,      PC_Rdst_Data_Out);
Control_Signals   : reg generic map (n   => 32) port map(clk, reset, Wr, Control_Signals_In,   Control_Signals_Out);
ALU_Result        : reg generic map (n   => 32) port map(clk, reset, Wr, ALU_Result_In,        ALU_Result_Out);
Read_Data2        : reg generic map (n   => 32) port map(clk, reset, Wr, Read_Data2_In,        Read_Data2_Out);
DST_SRC_Addresses : reg generic map (n   => 6)  port map(clk, reset, Wr, DST_SRC_Addresses_In, DST_SRC_Addresses_Out);

end architecture EX_Buffer_Arch;