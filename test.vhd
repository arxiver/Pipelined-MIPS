

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_STD.ALL;
entity test is 
port(
Data: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(31 downto 0);
Cout : out std_logic;
F : out std_logic_vector(31 downto 0));

end entity test;

architecture test_aarch of test is 
signal Fbuffer : unsigned(31 downto 0);
begin
----------------------------------------------------------------------------------
--Invert
F<=  std_logic_vector(shift_left(unsigned(Data),  to_integer(unsigned(S))));
--F<= std_logic_vector(Fbuffer);	 

end architecture test_aarch;